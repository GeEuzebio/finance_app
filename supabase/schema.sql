-- Schema inicial do finance_app no Supabase (Postgres).
--
-- Como aplicar: painel do Supabase > SQL Editor > New query > cole este
-- arquivo inteiro > Run. É idempotente o suficiente para rodar uma vez só
-- num projeto novo; para mudanças futuras, crie um novo arquivo de
-- migration em vez de editar este (mesma disciplina do ADR 0005/0002:
-- nunca editar uma migration já aplicada).
--
-- ⚠️ Segurança: não há autenticação nesta versão do app (uso privado,
-- compartilhado entre duas pessoas via a mesma SUPABASE_ANON_KEY — ver
-- docs/adr/0005-supabase.md). RLS fica LIGADO em todas as tabelas, com uma
-- política permissiva ("allow all") por tabela — na prática o acesso da
-- anon key é total, igual seria com RLS desligado, mas RLS ligado é o
-- padrão recomendado pelo Supabase (evita o aviso do Security Advisor) e
-- deixa o caminho pronto para apertar a política por usuário no dia em
-- que o app ganhar login, sem precisar lembrar de ligar RLS também.
-- ⚠️ A SUPABASE_SERVICE_ROLE_KEY nunca deve ser usada pelo app Flutter —
-- só por scripts/administração rodados fora do cliente.

create extension if not exists "pgcrypto";

create type account_type as enum ('checking', 'savings', 'wallet', 'other');
create type account_owner as enum ('eu', 'conjuge', 'conjunta');
create type transaction_status as enum ('previsto', 'confirmado', 'ajustado', 'adiado', 'cancelado');
create type recurrence_frequency as enum ('weekly', 'monthly', 'yearly', 'custom');
create type invoice_status as enum ('aberta', 'fechada', 'paga');

create table accounts (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type account_type not null,
  owner account_owner not null,
  initial_balance_cents bigint not null,
  initial_balance_date date not null,
  archived boolean not null default false,
  created_at timestamptz not null default now()
);

create table recurrence_rules (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts (id),
  description text not null,
  amount_cents bigint not null,
  frequency recurrence_frequency not null,
  recurrence_interval integer not null,
  start_date date not null,
  end_date date,
  occurrence_count integer,
  created_at timestamptz not null default now()
);

create table credit_cards (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  payment_account_id uuid not null references accounts (id),
  closing_day integer not null,
  due_day integer not null,
  limit_cents bigint,
  owner account_owner not null,
  created_at timestamptz not null default now()
);

create table invoices (
  id uuid primary key default gen_random_uuid(),
  credit_card_id uuid not null references credit_cards (id),
  reference_month text not null,
  closing_date date not null,
  due_date date not null,
  status invoice_status not null,
  created_at timestamptz not null default now()
  -- total_cents não é coluna: sempre agregado via SUM(amount_cents) sobre
  -- invoice_items (docs/ARCHITECTURE.md §5).
);

create table invoice_items (
  id uuid primary key default gen_random_uuid(),
  invoice_id uuid not null references invoices (id),
  description text not null,
  amount_cents bigint not null,
  purchase_date date not null,
  installment_number integer not null,
  installment_total integer not null,
  purchase_group_id uuid not null,
  created_at timestamptz not null default now()
);

create table transactions (
  id uuid primary key default gen_random_uuid(),
  account_id uuid not null references accounts (id),
  description text not null,
  amount_cents bigint not null,
  date date not null,
  status transaction_status not null,
  recurrence_rule_id uuid references recurrence_rules (id),
  original_transaction_id uuid references transactions (id),
  transfer_group_id uuid,
  invoice_payment_for_id uuid references invoices (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table reserves (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  target_amount_cents bigint,
  current_amount_cents bigint not null,
  created_at timestamptz not null default now()
);

-- Postgres não indexa FKs automaticamente — as buscas mais frequentes dos
-- repositórios/engine ganham índice explícito.
create index on transactions (account_id);
create index on transactions (recurrence_rule_id);
create index on invoice_items (invoice_id);
create index on invoices (credit_card_id);
create index on recurrence_rules (account_id);
create index on credit_cards (payment_account_id);

-- RLS ligado + política permissiva por tabela (ver nota de segurança no
-- topo do arquivo). Se o app ganhar login, troque o `using (true)` de cada
-- política por algo como `using (owner_id = auth.uid())` — não precisa
-- mexer no `enable row level security`, ele já está certo. Mesmo bloco de
-- supabase/policies.sql — mantenha os dois em sincronia se editar aqui.
alter table accounts enable row level security;
drop policy if exists "allow all - accounts" on accounts;
create policy "allow all - accounts" on accounts for all using (true) with check (true);

alter table recurrence_rules enable row level security;
drop policy if exists "allow all - recurrence_rules" on recurrence_rules;
create policy "allow all - recurrence_rules" on recurrence_rules for all using (true) with check (true);

alter table credit_cards enable row level security;
drop policy if exists "allow all - credit_cards" on credit_cards;
create policy "allow all - credit_cards" on credit_cards for all using (true) with check (true);

alter table invoices enable row level security;
drop policy if exists "allow all - invoices" on invoices;
create policy "allow all - invoices" on invoices for all using (true) with check (true);

alter table invoice_items enable row level security;
drop policy if exists "allow all - invoice_items" on invoice_items;
create policy "allow all - invoice_items" on invoice_items for all using (true) with check (true);

alter table transactions enable row level security;
drop policy if exists "allow all - transactions" on transactions;
create policy "allow all - transactions" on transactions for all using (true) with check (true);

alter table reserves enable row level security;
drop policy if exists "allow all - reserves" on reserves;
create policy "allow all - reserves" on reserves for all using (true) with check (true);
