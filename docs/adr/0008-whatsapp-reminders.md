# ADR 0008 — Lembretes por WhatsApp via Evolution API self-hosted

## Contexto
M7, #032: você pediu lembretes por WhatsApp de três tipos — contas a
vencer, pagamento (fatura de cartão) e um relatório periódico da
situação financeira do casal — usando a Evolution API, um gateway
open-source de WhatsApp (self-hosted, API REST autenticada por header
`apikey`, endpoint `POST /message/sendText/{instance}`).

Esta é a terceira ADR que trata de dado financeiro saindo do Supabase
(depois da 0006, que rejeitou `banco-mcp`/UPX por mandarem dado bancário
**automaticamente** pra um host de IA de terceiro sem escolha do
usuário, e da 0007, que aceitou mandar um resumo agregado pra Anthropic
sob opt-in explícito). Esta é estruturalmente diferente das outras
duas: a Evolution API não é um terceiro — é uma instância que **você
mesmo hospeda** (VPS/Docker próprio ou um provedor gerenciado tipo
Railway), e o destino final do dado é o **seu próprio WhatsApp**. Não
existe aqui um provedor de IA nem qualquer parte externa vendo o dado
financeiro do casal.

## Decisão
Implementar a feature inteiramente como infraestrutura server-side, sem
nenhuma mudança no app Flutter:

1. **Sem opt-in no app** — diferente da 0007, não há switch em
   Configurações. O gate de consentimento aqui é estrutural: nada roda
   até você hospedar a Evolution API, fazer o deploy manual da Edge
   Function e configurar os secrets. Como só existem duas pessoas
   usando este app (`PRODUCT.md`) e ambas controlam a própria infra, um
   toggle adicional seria redundante.
2. **Números de WhatsApp só via secret do Supabase**
   (`WHATSAPP_PHONE_1`/`WHATSAPP_PHONE_2`) — sem tabela nova, sem tela
   nova. Trocar um número é rodar `supabase secrets set` de novo.
3. **Agendamento via `pg_cron`/`pg_net`** (migration 0005) chamando a
   Edge Function `whatsapp-reminders` 1x/dia — mantém tudo dentro do
   Supabase já usado pelo app, sem introduzir um serviço de cron
   externo.
4. **Recorrências entram no lembrete de "contas"**: lançamentos
   recorrentes (aluguel, assinaturas) ainda não materializados em
   `Transaction` são a maioria das contas de uma casa, então a Edge
   Function porta uma versão de `expandRecurrence`
   (`lib/features/cashflow_engine/domain/recurrence_expansion.dart`)
   pro TypeScript. É uma segunda implementação da mesma regra de data —
   Deno não importa código Dart — o que carrega risco de divergência se
   a regra de recorrência mudar num lado e não no outro. Aceito
   conscientemente: o comentário no topo da function aponta o arquivo
   Dart como fonte da verdade, e qualquer mudança na regra de
   recorrência deve revisar os dois arquivos juntos.

## Consequências
- Zero mudança em `lib/` — toda a feature vive em
  `supabase/functions/whatsapp-reminders/` + uma migration. Superfície
  de risco no app Flutter é nula.
- Nova dependência operacional: uma instância Evolution API precisa
  ficar no ar (você hospeda e mantém). Se cair, os lembretes só param de
  sair — não afeta o app em si, que não depende dela pra nada.
- Lembretes de "conta a vencer" são idempotentes por construção (cada
  conta dispara exatamente uma vez, no dia exato N dias antes do
  vencimento) — mas isso significa que uma falha do cron nesse dia
  específico perde aquele lembrete silenciosamente, sem reenvio. Aceito
  como limitação de MVP; se isso incomodar na prática, a evolução natural
  é uma tabela de log de envio + checagem de janela em vez de dia exato.
- O relatório semanal usa uma versão simplificada de `summarizeMonth`
  (sem quebra por categoria) — números batem com o app pros totais
  (entrada/saída/economia), mas não é uma cópia pixel-a-pixel da tela
  Mês. Ponto único de leitura precisa (a "confiança em dinheiro" real)
  continua sendo o app; o WhatsApp é um resumo de conveniência.
- Duplicação da lógica de `expandRecurrence` em TypeScript (ver decisão
  4) é uma dívida técnica assumida conscientemente, não descoberta
  depois.

## Alternativas descartadas
- **WhatsApp Business Cloud API (oficial, Meta)**: não avaliada em
  profundidade porque você já pediu especificamente a Evolution API;
  exigiria conta comercial Meta e verificação de negócio, fricção maior
  que uma instância self-hosted pra um uso privado de duas pessoas.
- **Toggle de opt-in em Configurações** (mesmo padrão da 0007):
  descartado porque o gate de consentimento já existe em outro nível
  (deploy manual + secrets) — adicionar um segundo gate redundante não
  muda nada na prática pra um app de duas pessoas sem autenticação.
- **Tabela de configuração de números editável pelo app**: descartado
  por ora (decisão tomada com você) — números de telefone de duas
  pessoas praticamente não mudam; o custo de uma tela nova + tabela nova
  não se paga. Fica registrado como upgrade natural se isso incomodar.
- **Não incluir lançamentos recorrentes no lembrete de contas**: seria
  mais simples (zero duplicação de lógica), mas deixaria de fora a
  maioria real das contas de uma casa (aluguel, assinaturas) — decisão
  tomada com você de aceitar a duplicação em troca de cobertura real.
