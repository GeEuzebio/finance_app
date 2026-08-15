-- Migration 0003: identificador externo pra deduplicar importação de
-- fatura de cartão OFX/CSV (M7, #025 — mesmo motivo da 0002, mas pro
-- lado dos itens de fatura).
--
-- Como aplicar: painel do Supabase > SQL Editor > New query > cole este
-- arquivo > Run.

alter table invoice_items
  add column if not exists external_id text;

create unique index if not exists invoice_items_external_id_key
  on invoice_items (external_id)
  where external_id is not null;
