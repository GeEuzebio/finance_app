-- Migration 0004: categoria por propósito do gasto (M7, #029) — resposta
-- a "pra onde vai meu dinheiro", aditiva à previsibilidade do app, não
-- substitui a projeção. Default 'outros' pra não quebrar linha existente
-- (mesmo padrão de is_variable, migration 0001).
--
-- Como aplicar: painel do Supabase > SQL Editor > New query > cole este
-- arquivo > Run.

alter table transactions
  add column if not exists category text not null default 'outros';

alter table recurrence_rules
  add column if not exists category text not null default 'outros';

alter table invoice_items
  add column if not exists category text not null default 'outros';
