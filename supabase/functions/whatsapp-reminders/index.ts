// Edge Function (Deno) — roda 1x/dia via pg_cron
// (supabase/migrations/0005_whatsapp_reminders.sql). Avisa contas a vencer
// (avulsas, recorrentes e fatura de cartão) 3 dias antes, e manda um
// relatório da situação financeira toda segunda-feira. Envia via Evolution
// API (gateway self-hosted de WhatsApp) — o dado só sai do seu Supabase pro
// seu próprio WhatsApp, nenhum terceiro de IA envolvido (M7, #032, ADR 0008).

import { createClient, type SupabaseClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const EVOLUTION_API_URL = Deno.env.get("EVOLUTION_API_URL");
const EVOLUTION_API_KEY = Deno.env.get("EVOLUTION_API_KEY");
const EVOLUTION_INSTANCE = Deno.env.get("EVOLUTION_INSTANCE");
const PHONE_NUMBERS = [Deno.env.get("WHATSAPP_PHONE_1"), Deno.env.get("WHATSAPP_PHONE_2")]
  .filter((p): p is string => !!p);

// Sem campo configurável — ponytail MVP; se precisar variar, vira coluna
// numa tabela de config em vez de constante.
const ADVANCE_NOTICE_DAYS = 3;

function formatCents(cents: number): string {
  return `R$ ${(cents / 100).toFixed(2)}`;
}

function formatDateBr(iso: string): string {
  const [, m, d] = iso.split("-");
  return `${d}/${m}`;
}

// ---- Datas: yyyy-mm-dd, comparadas como string (ordena igual a data —
// mesmo valor de DateOnly.toString() em lib/core/utils/date_only.dart). ----

function toDateOnly(d: Date): string {
  return d.toISOString().split("T")[0];
}

function addDays(iso: string, days: number): string {
  const d = new Date(iso + "T00:00:00Z");
  d.setUTCDate(d.getUTCDate() + days);
  return toDateOnly(d);
}

// Espelha clampedMonthDate em lib/core/utils/date_only.dart — dia que não
// existe no mês (ex.: 31 em fevereiro) cai no último dia real do mês.
function clampedMonthDate(year: number, month: number, day: number): string {
  const lastDay = new Date(Date.UTC(year, month, 0)).getUTCDate();
  const clampedDay = Math.min(day, lastDay);
  return `${String(year).padStart(4, "0")}-${String(month).padStart(2, "0")}-${String(clampedDay).padStart(2, "0")}`;
}

// Espelha DateOnly.addMonths.
function addMonths(iso: string, months: number): string {
  const [y, m, d] = iso.split("-").map(Number);
  const monthsFromEpoch = m - 1 + months;
  const year = y + Math.floor(monthsFromEpoch / 12);
  const month = (((monthsFromEpoch % 12) + 12) % 12) + 1;
  return clampedMonthDate(year, month, d);
}

interface RecurrenceRuleRow {
  id: string;
  description: string;
  amount_cents: number;
  frequency: "weekly" | "monthly" | "yearly" | "custom";
  recurrence_interval: number;
  start_date: string;
  end_date: string | null;
  occurrence_count: number | null;
}

// Porta de lib/features/cashflow_engine/domain/recurrence_expansion.dart —
// tradução linha a linha (expandRecurrence + _nextOccurrence). Segunda
// implementação da mesma regra, não chama o código Dart: se a regra de
// recorrência mudar lá, atualizar aqui também.
function expandRecurrence(rule: RecurrenceRuleRow, from: string, to: string): string[] {
  const dates: string[] = [];
  let cursor = rule.start_date;
  let n = 0;
  const effectiveEnd = rule.end_date ?? to;

  while (
    cursor <= to &&
    cursor <= effectiveEnd &&
    (rule.occurrence_count == null || n < rule.occurrence_count)
  ) {
    if (cursor >= from) dates.push(cursor);
    n += 1;
    cursor = nextOccurrence(rule, n);
  }
  return dates;
}

function nextOccurrence(rule: RecurrenceRuleRow, n: number): string {
  switch (rule.frequency) {
    case "weekly":
      return addDays(rule.start_date, n * 7);
    case "monthly":
      return addMonths(rule.start_date, n * rule.recurrence_interval);
    case "yearly": {
      const [y, m, d] = rule.start_date.split("-").map(Number);
      return clampedMonthDate(y + n * rule.recurrence_interval, m, d);
    }
    case "custom":
      return addDays(rule.start_date, n * rule.recurrence_interval);
  }
}

// ---- Contas a vencer (dispara todo dia; idempotente por checar só o dia
// exato ADVANCE_NOTICE_DAYS à frente, não uma janela — se o cron falhar
// de rodar num dia, aquele lembrete específico é perdido). ----

async function buildBillsMessage(supabase: SupabaseClient, today: string): Promise<string | null> {
  const targetDate = addDays(today, ADVANCE_NOTICE_DAYS);
  const lines: string[] = [];

  const { data: pointTx } = await supabase
    .from("transactions")
    .select("description, amount_cents")
    .eq("status", "previsto")
    .eq("date", targetDate);
  for (const t of pointTx ?? []) {
    lines.push(`- ${t.description}: ${formatCents(t.amount_cents)}`);
  }

  const { data: rules } = await supabase
    .from("recurrence_rules")
    .select(
      "id, description, amount_cents, frequency, recurrence_interval, start_date, end_date, occurrence_count",
    )
    .lte("start_date", targetDate);
  const { data: overrides } = await supabase
    .from("transactions")
    .select("recurrence_rule_id")
    .eq("date", targetDate)
    .not("recurrence_rule_id", "is", null);
  const overriddenRuleIds = new Set((overrides ?? []).map((o) => o.recurrence_rule_id));
  for (const rule of (rules ?? []) as RecurrenceRuleRow[]) {
    if (overriddenRuleIds.has(rule.id)) continue;
    if (expandRecurrence(rule, targetDate, targetDate).length > 0) {
      lines.push(`- ${rule.description}: ${formatCents(rule.amount_cents)}`);
    }
  }

  const { data: invoices } = await supabase
    .from("invoices")
    .select("id, credit_cards(name)")
    .neq("status", "paga")
    .eq("due_date", targetDate);
  for (const invoice of invoices ?? []) {
    const { data: items } = await supabase
      .from("invoice_items")
      .select("amount_cents")
      .eq("invoice_id", invoice.id);
    const total = (items ?? []).reduce((sum, i) => sum + i.amount_cents, 0);
    const cardName = (invoice.credit_cards as { name?: string } | null)?.name ?? "cartão";
    lines.push(`- Fatura ${cardName}: ${formatCents(-total)}`);
  }

  if (lines.length === 0) return null;
  return `🔔 Contas vencendo em ${ADVANCE_NOTICE_DAYS} dias (${formatDateBr(targetDate)}):\n${lines.join("\n")}`;
}

// ---- Relatório semanal (dispara só às segundas) — versão enxuta de
// summarizeMonth em lib/features/cashflow_engine/domain/monthly_summary.dart,
// sem quebra por categoria (evita depender da coluna category, cuja
// migração 0004 pode ainda não estar aplicada). ----

async function buildReportMessage(supabase: SupabaseClient, today: string): Promise<string> {
  const [y, m] = today.split("-").map(Number);
  const monthStart = `${y}-${String(m).padStart(2, "0")}-01`;
  const monthEnd = clampedMonthDate(y, m, 32);

  const { data: pointTx } = await supabase
    .from("transactions")
    .select("amount_cents, invoice_payment_for_id, status")
    .gte("date", monthStart)
    .lte("date", monthEnd)
    .not("status", "in", "(cancelado,adiado)");

  let incomeCents = 0;
  let expensesCents = 0;
  for (const t of pointTx ?? []) {
    if (t.amount_cents > 0) incomeCents += t.amount_cents;
    else if (t.invoice_payment_for_id == null) expensesCents += -t.amount_cents;
  }

  const { data: rules } = await supabase
    .from("recurrence_rules")
    .select("id, amount_cents, frequency, recurrence_interval, start_date, end_date, occurrence_count")
    .lte("start_date", monthEnd);
  const { data: overrides } = await supabase
    .from("transactions")
    .select("recurrence_rule_id, date")
    .gte("date", monthStart)
    .lte("date", monthEnd)
    .not("recurrence_rule_id", "is", null);
  const overriddenSlots = new Set(
    (overrides ?? []).map((o) => `${o.recurrence_rule_id}|${o.date}`),
  );
  for (const rule of (rules ?? []) as RecurrenceRuleRow[]) {
    for (const date of expandRecurrence(rule, monthStart, monthEnd)) {
      if (overriddenSlots.has(`${rule.id}|${date}`)) continue;
      if (rule.amount_cents > 0) incomeCents += rule.amount_cents;
      else expensesCents += -rule.amount_cents;
    }
  }

  const { data: invoiceItems } = await supabase
    .from("invoice_items")
    .select("amount_cents")
    .gte("purchase_date", monthStart)
    .lte("purchase_date", monthEnd);
  const cardSpendCents = -(invoiceItems ?? []).reduce((sum, i) => sum + i.amount_cents, 0);

  const costOfLivingCents = expensesCents + cardSpendCents;
  const savedCents = incomeCents - costOfLivingCents;
  const savingsPercent = incomeCents === 0 ? 0 : (savedCents / incomeCents) * 100;

  const { data: overdueInvoices } = await supabase
    .from("invoices")
    .select("id")
    .neq("status", "paga")
    .lt("due_date", today);
  let overdueCents = 0;
  for (const invoice of overdueInvoices ?? []) {
    const { data: items } = await supabase
      .from("invoice_items")
      .select("amount_cents")
      .eq("invoice_id", invoice.id);
    overdueCents += (items ?? []).reduce((sum, i) => sum + i.amount_cents, 0);
  }

  const lines = [
    `📊 Situação financeira — ${formatDateBr(monthStart)} a ${formatDateBr(today)}`,
    `Entradas: ${formatCents(incomeCents)}`,
    `Saídas: ${formatCents(costOfLivingCents)}`,
    `Economizado: ${formatCents(savedCents)} (${savingsPercent.toFixed(1)}% da renda)`,
  ];
  if (overdueCents < 0) lines.push(`Fatura atrasada: ${formatCents(-overdueCents)}`);
  return lines.join("\n");
}

async function sendWhatsApp(number: string, text: string) {
  const res = await fetch(`${EVOLUTION_API_URL}/message/sendText/${EVOLUTION_INSTANCE}`, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      apikey: EVOLUTION_API_KEY!,
    },
    body: JSON.stringify({ number, text }),
  });
  if (!res.ok) {
    return { number, ok: false, error: await res.text() };
  }
  return { number, ok: true };
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }
  if (!EVOLUTION_API_URL || !EVOLUTION_API_KEY || !EVOLUTION_INSTANCE) {
    return new Response(JSON.stringify({ error: "Evolution API not configured" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
  if (PHONE_NUMBERS.length === 0) {
    return new Response(JSON.stringify({ error: "no WHATSAPP_PHONE_* configured" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);
  // UTC e BRT caem no mesmo dia calendário no horário fixo do cron
  // (11:00 UTC = 08:00 BRT) — se o horário do cron mudar pra perto da
  // meia-noite BRT, isso precisa virar conversão de fuso de verdade.
  const today = toDateOnly(new Date());

  const messages: string[] = [];
  const billsMessage = await buildBillsMessage(supabase, today);
  if (billsMessage) messages.push(billsMessage);

  const isMonday = new Date(`${today}T00:00:00Z`).getUTCDay() === 1;
  if (isMonday) messages.push(await buildReportMessage(supabase, today));

  const results = [];
  for (const text of messages) {
    for (const number of PHONE_NUMBERS) {
      results.push(await sendWhatsApp(number, text));
    }
  }

  return new Response(JSON.stringify({ sent: messages.length, results }), {
    headers: { "Content-Type": "application/json" },
  });
});
