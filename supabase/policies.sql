-- RLS + políticas permissivas, isolado do schema.sql para quem já criou as
-- tabelas (pelo SQL Editor ou pelo Table Editor da UI) e só precisa
-- aplicar isto agora. Se você ainda vai rodar o schema.sql pela primeira
-- vez, pode ignorar este arquivo — ele já inclui este bloco no final.
--
-- Sem isso, uma tabela com "Enable RLS" marcado e nenhuma política
-- rejeita TODO acesso, inclusive da anon key que o app usa.
--
-- Idempotente: dá pra rodar de novo sem erro (drop if exists antes de
-- cada create policy — "create policy" sozinho não suporta "if not exists").

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
