// Edge Function (Deno) — recebe o resumo agregado do mês (sem lançamento
// individual) e pede à Anthropic 3 sugestões curtas de como reduzir gasto
// e melhorar a economia. Chave da API só existe aqui, nunca no app
// Flutter (M7, #031, ADR 0007).

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY");
const MODEL = "claude-haiku-4-5";

interface InsightsPayload {
  categoryCents: Record<string, number>;
  necessidadesCents: number;
  desejosCents: number;
  reservaCents: number;
  savedCents: number;
  savingsPercent: number;
  overdueCents: number;
}

function formatCents(cents: number): string {
  return `R$ ${(cents / 100).toFixed(2)}`;
}

function buildPrompt(payload: InsightsPayload): string {
  const categoryLines = Object.entries(payload.categoryCents)
    .map(([label, cents]) => `- ${label}: ${formatCents(cents)}`)
    .join("\n");

  return `Você ajuda um casal brasileiro a organizar as finanças e parar de \
depender do cartão de crédito. Não recalcule nenhum valor abaixo — eles já \
são exatos, use-os como estão.

Gastos por categoria neste mês:
${categoryLines || "(nenhum gasto categorizado ainda)"}

Guia 50/30/20 (necessidades/desejos/reserva):
- Necessidades: ${formatCents(payload.necessidadesCents)}
- Desejos: ${formatCents(payload.desejosCents)}
- Reserva (sobra do mês): ${formatCents(payload.reservaCents)}

Economia do mês: ${formatCents(payload.savedCents)} (${payload.savingsPercent.toFixed(1)}% da renda)
Dívida de fatura de cartão atrasada: ${formatCents(payload.overdueCents)}

Dê exatamente 3 sugestões curtas, específicas e acionáveis em português, \
priorizando reduzir a dependência do cartão de crédito e melhorar a \
economia. Responda só com um array JSON de 3 strings, sem nenhum texto \
antes ou depois. Formato: ["sugestão 1", "sugestão 2", "sugestão 3"]`;
}

function parseSuggestions(text: string): string[] {
  try {
    const parsed = JSON.parse(text);
    if (Array.isArray(parsed) && parsed.every((item) => typeof item === "string")) {
      return parsed;
    }
  } catch {
    // cai no fallback abaixo
  }
  // ponytail: modelo não seguiu o formato — devolve o texto cru como
  // sugestão única em vez de falhar silenciosamente.
  return [text.trim()];
}

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }
  if (!ANTHROPIC_API_KEY) {
    return new Response(JSON.stringify({ error: "ANTHROPIC_API_KEY not configured" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  const payload = (await req.json()) as InsightsPayload;

  const anthropicRes = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
    },
    body: JSON.stringify({
      model: MODEL,
      max_tokens: 500,
      messages: [{ role: "user", content: buildPrompt(payload) }],
    }),
  });

  if (!anthropicRes.ok) {
    const text = await anthropicRes.text();
    return new Response(JSON.stringify({ error: `Anthropic API error: ${text}` }), {
      status: 502,
      headers: { "Content-Type": "application/json" },
    });
  }

  const anthropicData = await anthropicRes.json();
  const text = anthropicData.content?.[0]?.text ?? "[]";

  return new Response(JSON.stringify({ suggestions: parseSuggestions(text) }), {
    headers: { "Content-Type": "application/json" },
  });
});
