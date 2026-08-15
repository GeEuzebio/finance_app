-- Migration 0002: identificador externo pra deduplicar importação de
-- extrato OFX/CSV (M7, #023 — sem isso, importar o mesmo período duas
-- vezes duplicaria cada lançamento e corromperia a previsão de saldo).
--
-- Como aplicar: painel do Supabase > SQL Editor > New query > cole este
-- arquivo > Run.

alter table transactions
  add column if not exists external_id text;

create unique index if not exists transactions_external_id_key
  on transactions (external_id)
  where external_id is not null;
