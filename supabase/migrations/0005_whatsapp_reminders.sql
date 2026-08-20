-- Migration 0005: agenda o disparo diário da Edge Function
-- whatsapp-reminders via pg_cron (M7, #032, ADR 0008). A function em si
-- não precisa de tabela nova — números de WhatsApp e credenciais da
-- Evolution API são secrets do Supabase, não dado de linha.
--
-- ⚠️ Antes de rodar: troque os dois placeholders abaixo pelos valores do
-- SEU projeto (Project Settings > API no painel do Supabase) — nenhum dos
-- dois é segredo (a anon key já vive no seu .env/dart-define do app), só
-- servem pra passar na verificação de JWT da Edge Function.
--
-- Como aplicar: painel do Supabase > SQL Editor > New query > cole este
-- arquivo (já com os placeholders trocados) > Run.

create extension if not exists pg_cron;
create extension if not exists pg_net;

select cron.schedule(
  'whatsapp-reminders-daily',
  '0 11 * * *', -- 08:00 BRT
  $$
  select net.http_post(
    url := 'https://<SEU_PROJECT_REF>.supabase.co/functions/v1/whatsapp-reminders',
    headers := jsonb_build_object(
      'Authorization', 'Bearer <SUA_SUPABASE_ANON_KEY>',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);
