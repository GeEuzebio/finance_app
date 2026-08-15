-- Migration 0001: distingue conta fixa de conta variável em
-- recurrence_rules (Lançamentos — ver docs/ROADMAP.md).
--
-- Como aplicar: painel do Supabase > SQL Editor > New query > cole este
-- arquivo > Run.

alter table recurrence_rules
  add column if not exists is_variable boolean not null default false;
