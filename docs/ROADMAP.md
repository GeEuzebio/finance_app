# Roadmap

> Milestones e issues numeradas. Issues de M0–M5 (domínio + dados) estão
> detalhadas o suficiente para implementação direta. M0–M6 estão
> implementados; o que resta é só o Backlog abaixo.

## M0 — Fundação

### #001 — Setup do core + DI + camada base
Objetivo: estrutura mínima do projeto compilando, com DI e conexão de banco
funcionando, sem nenhuma tabela de feature ainda.
Ver especificação completa em `docs/issues/0001-setup-core.md`.
Dependências: nenhuma.

### #002 — Schema Postgres completo (Supabase)
> Reescrito após o ADR 0005 (migração de Drift local para Supabase) — a
> versão original desta issue (schema Drift + `PRAGMA foreign_keys`) está
> só no histórico do ADR 0002.

Objetivo: as 7 tabelas de `docs/ARCHITECTURE.md` §5 como SQL em
`supabase/schema.sql` (`accounts`, `transactions`, `recurrence_rules`,
`credit_cards`, `invoices`, `invoice_items`, `reserves`), com foreign keys,
enums nativos do Postgres e índices nas colunas de busca mais frequente.
Critérios de aceite:
- Todas as 7 tabelas existem exatamente como especificado em ARCHITECTURE.md.
- `schema.sql` roda sem erro num projeto Supabase novo (SQL Editor).
- Foreign keys declaradas entre todas as tabelas relacionadas.
Dependências: #001.

### #003 — Catálogo de Failure
Objetivo: implementar a hierarquia `Failure` de `docs/ARCHITECTURE.md` §6.
Critérios de aceite:
- `ValidationFailure`, `NotFoundFailure`, `DatabaseFailure`,
  `ProjectionFailure` implementadas como `sealed class`.
- Teste garante que cada subtipo carrega sua mensagem corretamente.
Dependências: #001.

## M1 — Cashflow Engine (domínio puro)

### #004 — Entidades de domínio
Objetivo: implementar as 8 entidades (`Account`/`AccountSnapshot`,
`Transaction`, `RecurrenceRule`, `CreditCard`, `Invoice`, `InvoiceItem`,
`Reserve`, `DailyBalance`) como classes `freezed` em `domain/entities`,
Dart puro (sem Flutter, sem Supabase).
Critérios de aceite:
- Campos e tipos batem exatamente com `docs/ARCHITECTURE.md` §4.
- Nenhum import de `flutter`, `supabase_flutter` ou `riverpod` nesses arquivos.
Dependências: #001.

### #005 — Implementação de `projectCashflow`
Objetivo: implementar a função pura descrita em `docs/CASHFLOW_ENGINE.md`
§1–§3 (expansão de recorrência, resolução de fatura em débito, acumulação
diária, consolidação, saldo livre).
Critérios de aceite:
- Assinatura idêntica à de `docs/CASHFLOW_ENGINE.md` §1.
- Sem nenhuma chamada de I/O ou `DateTime.now()` dentro da função.
Dependências: #004.

### #006 — Suite de testes da engine
Objetivo: os 15 casos de teste da tabela em `docs/CASHFLOW_ENGINE.md` §5,
mais um benchmark de performance.
Critérios de aceite:
- Um `test()` por linha da tabela (mínimo 15), todos verdes.
- Benchmark: 12 meses × 500 lançamentos roda em < 50ms (falha o teste se
  ultrapassar, rodando em CI).
Dependências: #005.

## M2 — Persistência & Repositórios

### #007 — Mapeamento JSON ↔ entidade
> Reescrito após o ADR 0005 — sem DAOs Drift, o Supabase é acessado direto
> via `SupabaseClient` dentro de cada `XRepositoryImpl` (#008); esta issue
> ficou responsável só pelas funções puras de mapeamento.

Objetivo: uma função `xFromJson`/`xToJson` por entidade persistida
(colocadas junto do respectivo `XRepositoryImpl`), convertendo
`Map<String, dynamic>` do Postgrest ↔ entidade de domínio, incluindo a
soma de `amount_cents` por `invoiceId` para `Invoice.totalCents`.
Critérios de aceite:
- Roundtrip `xFromJson(xToJson(x)) == x` testado para as 7 entidades, sem
  precisar de conexão de rede.
- Nomes de coluna batem com `supabase/schema.sql` (`snake_case`).
Dependências: #002.

### #008 — Repositórios
Objetivo: implementar os contratos `XRepository` de `domain` na camada
`data`, usando `SupabaseClient` + o mapeamento de #007, convertendo
exceções do Postgrest para `Either<Failure, T>` via `guardDatabase`.
Critérios de aceite:
- Nenhuma exception do Supabase/Postgrest escapa da camada `data` — tudo
  vira `Left(DatabaseFailure(...))` no boundary (`guardDatabase`).
- Busca por id ausente devolve `Left(NotFoundFailure(...))`.
- Um `XRepositoryImpl` por entidade/cluster persistido, anotado
  `@LazySingleton(as: XRepository)`.
- ⚠️ gap conhecido: sem Supabase CLI/instância local disponível nesta
  sessão, não há teste de integração real contra o Postgres — só os
  roundtrips de mapeamento (#007). Fica para quando houver ambiente local
  (`supabase start`, Docker já disponível).
Dependências: #003, #007.

## M3 — Recorrência

### #009 — CRUD de RecurrenceRule
Objetivo: casos de uso de criar regra, editar 1 ocorrência, editar "esta e
as futuras" (split simples, ADR 0004) e editar a série inteira.
Critérios de aceite:
- Editar "esta e as futuras" produz exatamente 2 `RecurrenceRule`s no banco
  (a antiga com `endDate` preenchido, a nova a partir da data escolhida).
- Editar 1 ocorrência nunca cria/altera uma `RecurrenceRule`.
Dependências: #008.

### #010 — Materialização de ocorrências para a engine
Objetivo: caso de uso que busca regras + transações concretas de um
horizonte e alimenta `projectCashflow` (junta #005 com #008).
Critérios de aceite:
- Chamada real ao repositório + engine produz `DailyBalance`s consistentes
  com os casos de `docs/CASHFLOW_ENGINE.md` §5 rodando contra o banco real.
Dependências: #006, #009.

## M4 — Cartões

### #011 — Cadastro de compra e parcelamento
Objetivo: caso de uso de registrar uma `InvoiceItem` (à vista ou parcelada),
aplicando a regra de fechamento e a fórmula de distribuição de parcelas com
resíduo (`docs/CASHFLOW_ENGINE.md` §3).
Critérios de aceite:
- Compra em 3x de R$100,00 gera parcelas `-3334, -3333, -3333` em faturas
  consecutivas corretas.
- Compra no dia exato do fechamento cai na fatura atual (caso #7 da engine).
Dependências: #008.

### #012 — Pagamento de fatura e estorno
Objetivo: caso de uso de marcar fatura como paga (gera `Transaction` de
débito) e de lançar estorno (`InvoiceItem` positivo).
Critérios de aceite:
- Fatura com total zerado por estorno não gera `Transaction` de pagamento
  (caso #15 da engine).
Dependências: #011.

## M5 — Reservas

### #013 — CRUD de Reserve e saldo livre
Objetivo: casos de uso de criar reserva, aportar (incrementa
`currentAmountCents` sem gerar `Transaction`), resgatar/excluir; exposição
do `freeBalanceCents` já calculado pela engine.
Critérios de aceite:
- Aportar em reserva não cria nenhuma linha em `Transactions`.
- `freeBalanceCents` consolidado reflete a soma de todas as reservas
  (caso #11 da engine).
Dependências: #006, #008.

## M6 — Superfícies de produto

- #014 — Tela de projeção diária (pilar 1)
- #015 — Tela de Check-in Diário (pilar 2)
- #016 — Tela de gestão de cartões (pilar 3)
- #017 — Tela de reservas e objetivos (pilar 4)

Dependências: toda a M0–M5. Design: `DESIGN.md` (identidade "Horizonte").

## M7 — Lançamentos, Configurações e Cálculo do Mês

Motivado por uma lacuna encontrada após o M6: não existia nenhuma tela
para cadastrar um lançamento avulso nem uma conta recorrente — só dava
pra criar contas, cartões e reservas. `CreateRecurrenceRule` e
`TransactionRepository.upsert` existiam desde o M3 sem nenhuma UI. Sem
isso o app não tinha como ser usado de verdade (Projeção e Check-in só
tinham o que fosse inserido via SQL direto no Supabase).

Referência de produto: Planilha do Breno (`planilhadobreno.com.br`) —
conceitos de Performance/Economizado/Custo de Vida/Diário Médio, adaptados
ao modelo de dados existente (sem reabrir categorização de gasto).

### #018 — Lançamentos (avulsos, fixas, variáveis)
Objetivo: tela `LancamentosScreen` pra cadastrar lançamento avulso
(`CreateTransaction`, novo caso de uso) e conta recorrente fixa/variável
(`CreateRecurrenceRule`, já existia). Diferença entre fixa e variável é
uma flag nova (`RecurrenceRule.isVariable`, coluna
`recurrence_rules.is_variable` — `supabase/migrations/0001_recurrence_is_variable.sql`),
ignorada pela engine (mesmo comportamento), usada só pra agrupar a lista.
Status: concluído.

### #019 — Configurações (tema, notificações, mover Contas)
Objetivo: área de Configurações com tema claro/escuro (antes
`ThemeMode.system` fixo em `main.dart`), preferências gerais (horizonte de
projeção, meta de economia) e navegação pra Contas/Cartões/Reservas — via
`SettingsController` (`lib/features/settings/`) sobre `shared_preferences`
(promovido de dev_dependencies pra dependencies). Sem repositório/Either
— simplificação deliberada, ver comentário `ponytail:` em
`settings_providers.dart`. Bottom nav reduzida de 6 pra 4 abas (Projeção,
Lançamentos, Check-in, Configurações — depois 5 com Mês, #021);
Contas/Cartões/Reservas só se chega por dentro de Configurações agora.
Toggle de notificação foi adicionado de fato no #022 (mesma sessão).
Status: concluído.

### #020 — Projeção em formato planilha
Objetivo: `ProjectionScreen` reescrita como grade (Dia / Movimento com
lançamento rápido inline / Saldo). Cada linha tem dropdown
entrada/saída + campo de valor + botão de confirmar, que abre um diálogo
mínimo (conta + descrição) e cria um `Transaction` avulso na data da
linha via `CreateTransaction` (mesma reutilizada pelo #018). Sem mudança
na engine, no use case nem no provider — só o horizonte passou a vir de
Configurações (#019). Validado no simulador: saldo recalcula
corretamente a partir do dia exato do lançamento inserido. Status:
concluído.

### #021 — Aba "Mês" (Performance / Economia / Custo de vida)
Objetivo: `GetMonthlySummary` + função pura `summarizeMonth`
(`lib/features/cashflow_engine/domain/monthly_summary.dart`). Custo de
vida = saídas (excluindo pagamento de fatura, já contado como saída da
conta) + gastos com cartão do mês (por data de compra, via `InvoiceItem`)
— decisão explícita pra não contar compra de cartão duas vezes. Validado
no simulador com dado real: fatura de R$300 paga no mês continua contando
uma vez só (R$500 saída + R$300 cartão = R$800 custo de vida, não
R$1.100). ⚠️ Limitação: `Reserve` não tem histórico (`Contribute`/
`Withdraw` mutam `current_amount_cents` no lugar, nunca geram
`Transaction`), então "economizado" é sobra do mês, não aporte em
reserva. Status: concluído.

### #022 — Notificações
Objetivo: lembrete diário de check-in via `flutter_local_notifications` +
`timezone`, agendado com `zonedSchedule`/`matchDateTimeComponents.time`
(recorrência diária no mesmo horário, sem precisar reagendar todo dia) e
`AndroidScheduleMode.inexactAllowWhileIdle` (evita exigir a permissão
`SCHEDULE_EXACT_ALARM` — um lembrete não precisa de precisão ao minuto).
`NotificationService` fica em `lib/features/notifications/`, registrado
no DI junto de `FlutterLocalNotificationsPlugin` (módulo em
`injection.dart`, mesmo padrão do `SupabaseClient`).

⚠️ Bug encontrado e corrigido na validação: `DarwinInitializationSettings`
pede permissão de notificação sozinho por padrão
(`requestAlertPermission`/`Badge`/`Sound` = `true`), o que disparava o
prompt do iOS no boot do app, antes de qualquer interação do usuário —
contra o princípio de produto "sem fricção" (`PRODUCT.md`). Corrigido
passando os 3 como `false` na inicialização; a permissão só é pedida
quando o usuário liga o lembrete em Configurações
(`SettingsController.setCheckInReminder`).

Validado no simulador iOS: boot sem prompt, toggle liga → pede permissão
→ agenda → persiste ("Todo dia às 20:00" + linha "Horário" aparece);
toggle desliga → cancela e some a linha "Horário". Android:
`POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED` e o
`ScheduledNotificationBootReceiver` no `AndroidManifest.xml` (não testado
em device Android nesta sessão, só revisão de código — sem simulador
Android disponível). Status: concluído.

Dependências: M0–M6.

### #023 — Importação de extrato OFX/CSV
Objetivo: fechar a decisão do Backlog (import OFX/CSV em vez de
integração bancária — `docs/adr/0006-open-finance.md`). Escopo desta
issue é **extrato** (lançamentos de conta) — import de **fatura** de
cartão fica de fora por ora (produziria `InvoiceItem`/parcelamento, não
`Transaction`; a máquina de #016 já existe, mas ligar um importador nela
é escopo à parte, não essencial pra provar o pipeline OFX/CSV).

- `parseOfx`/`parseCsv` (`lib/features/imports/domain/`) — funções puras,
  sem I/O. OFX é SGML (tags de folha sem fechamento), por isso o parser é
  regex por campo dentro de cada bloco `<STMTTRN>`, não um parser XML de
  verdade. CSV não tem padrão único no Brasil — o parser detecta
  delimitador (`,`/`;`) e reconhece cabeçalho por nome de coluna
  (Data/Descrição/Valor em qualquer ordem), com decimal BR (vírgula) ou
  US (ponto).
- **Deduplicação**: campo novo `Transaction.externalId` (nullable,
  índice único parcial — `supabase/migrations/0002_transaction_external_id.sql`).
  OFX usa o `FITID` do próprio arquivo; CSV (sem id estável) usa uma
  string determinística `data|descrição|valor`. Reimportar o mesmo
  período soma zero duplicata — só marca como `skipped`. Sem isso,
  reimportar corromperia a previsão de saldo silenciosamente (contraria
  "confiança em dinheiro", `PRODUCT.md`).
- `ImportTransactions` grava com `status: confirmado` (é extrato — já
  aconteceu, diferente de `previsto`).
- UI (`ImportScreen`, alcançável só por Configurações > Dados > Importar
  extrato) usa `file_picker` — pacote novo, único desta issue.

⚠️ **Bug de build encontrado e corrigido na validação**: `file_picker`
exige iOS 14+; o projeto ainda mirava iOS 13 (`Podfile`,
`IPHONEOS_DEPLOYMENT_TARGET` no `.pbxproj`, `MinimumOSVersion` no
`AppFrameworkInfo.plist`). Build falhava na instalação dos Pods.
Corrigido subindo os três pra 14.0. Validado no simulador: app sobe,
`FilePicker.pickFile()` abre o seletor nativo de documentos do iOS de
verdade (prova de que a integração nativa funciona pós-correção). Fluxo
completo de parse+import não foi exercitado ponta a ponta no simulador
(exigiria colocar um arquivo de teste no sistema de arquivos do
simulador) — coberto por 10 testes unitários (`ofx_parser_test.dart`,
`csv_parser_test.dart`, `import_transactions_test.dart`, incluindo o
caso de deduplicação). Status: concluído.

### #024 — Saldo comprometido com fatura de cartão em aberto
Objetivo: parte 2 da "análise de risco financeiro" do Backlog (parte 1,
alerta de saldo negativo, já saiu no #014) — motivação original do
usuário: "meu dinheiro serve pra pagar a fatura do cartão, e eu uso o
cartão o resto do mês ficando refém dele". `GetCommittedCardBalance`
(`lib/features/credit_cards/domain/usecases/`) soma `InvoiceItem.amountCents`
de todas as faturas com `status != paga`, direto sobre os itens (evita
N+1 chamando `totalCentsForInvoice` fatura por fatura, mesmo padrão de
`project_cashflow.dart` §3). Exposto como banner no topo da `ProjectionScreen`,
só quando há valor comprometido.

⚠️ **Decisão de design**: é um retrato de **hoje**, não um valor por dia
da projeção — a engine já sintetiza o débito da fatura na data de
vencimento (`project_cashflow.dart` §3), então aplicar esse desconto em
todo dia do horizonte contaria a mesma fatura duas vezes a partir do
vencimento. Por isso não foi dobrado dentro de `freeBalanceCents`
(que já existe pra reservas) — vive como um indicador separado.

Validado no simulador com fatura aberta de R$450,00: banner mostra
"-R$ 450,00" e a coluna Saldo da grade permanece inalterada (prova de que
não há dupla contagem). 2 testes unitários
(`get_committed_card_balance_test.dart`). Status: concluído.

### #025 — Importação de fatura de cartão (OFX/CSV)
Objetivo: fechar o item de Backlog que o #023 deixou de fora — mesmo
parser (`parseOfx`/`parseCsv`), mas gerando `InvoiceItem` em vez de
`Transaction`.

- `ImportInvoiceItems` (`lib/features/credit_cards/domain/usecases/`)
  roteia cada linha pra fatura do ciclo certo via `FindOrCreateInvoice`
  (mesma que #011 usa) e grava como item avulso (`installmentNumber: 1,
  installmentTotal: 1` — o extrato de fatura já traz cada parcela como
  linha própria, não é uma compra parcelada nova).
- **Deduplicação**: mesmo esquema do #023 — campo novo
  `InvoiceItem.externalId` (nullable, índice único parcial —
  `supabase/migrations/0003_invoice_item_external_id.sql`, ⚠️ **ainda não
  aplicada no Supabase**, precisa rodar manualmente no SQL Editor antes de
  a importação de fatura funcionar contra dados reais).
- `ImportScreen` ganhou um `SegmentedButton` Extrato/Fatura: Extrato
  continua indo pra conta (`Transaction`, fluxo do #023 inalterado);
  Fatura vai pra cartão (`InvoiceItem`, dropdown de cartões via
  `creditCardsControllerProvider`). Import de fatura invalida
  `cardDetailControllerProvider(cartão)`, `monthlyProjectionProvider` (#026)
  e `committedCardBalanceProvider` (#024) depois de persistir.
- 2 testes unitários (`import_invoice_items_test.dart`): importa 1x na
  fatura certa; pula item cujo `externalId` já existe sem chamar
  `findOrCreateInvoice` nem `upsertItem`.

Validado no simulador: toggle Extrato/Fatura e dropdown de cartão
renderizam corretamente com conta e cartão reais semeados via Supabase
REST (removidos ao fim). Fluxo completo de parse+import de fatura não foi
exercitado ponta a ponta — depende da migração 0003, que exige acesso
direto ao Postgres que este ambiente não tem. Status: concluído no
código; **pendente a migração manual pra funcionar em produção**.

### #026 — Projeção com seletor de mês/ano, detalhamento por dia e gradiente de saldo
Pedido do usuário (referência: planilha do Breno) — reformula a grade da
Projeção pra navegar por mês em vez de um horizonte fixo de dias, resumir
cada dia como uma diferença (em vez do lançamento rápido inline do #020,
que este item substitui) e abrir um detalhamento ao tocar no dia.

- `monthlyProjectionProvider(year, month)` (`projection_providers.dart`)
  substitui `dailyProjectionProvider` — a engine (`GetDailyProjection`) já
  aceitava `horizonStart`/`horizonEnd` livres, então navegar mês a mês é
  só trocar os dois parâmetros, sem tocar na engine. Os 6 pontos que
  invalidavam `dailyProjectionProvider` (contas, cartões, reservas,
  check-in, lançamentos, importação) passaram a invalidar
  `monthlyProjectionProvider` inteiro (família, sem args — invalida todas
  as instâncias) e o novo `dayLedgerProvider`.
- **Coluna Diferença**: `projectedCreditsCents - projectedDebitsCents` do
  próprio `DailyBalance` — nenhum campo novo na engine.
- **Gradiente de saldo**: `Color.lerp` entre `AppColors.debit` e
  `AppColors.credit`, normalizado pelo maior `|saldo|` do mês em exibição
  (não um limiar fixo) — dia com saldo baixo/negativo tende a vermelho,
  saldo alto tende a verde, ambos escuros nos extremos do próprio mês.
- **`GetDayLedger`** (`lib/features/transactions/domain/usecases/`) — novo
  use case pro detalhamento por dia (`DayDetailScreen`), generalização de
  `GetTodayCheckInItems` (M6 #015) pra um dia qualquer e sem o filtro "só
  previsto": um dia já confirmado/ajustado continua aparecendo, porque
  aqui é um extrato, não uma fila de ação. Também resolve o débito
  sintético de fatura vencendo naquele dia (mesma regra de
  `project_cashflow.dart` §3: só entra se `totalCents != 0` e não há
  `Transaction` de pagamento concreta), senão a soma do detalhamento não
  bateria com a Diferença da grade.
- Botão "+" (FAB) na Projeção abre o mesmo diálogo de lançamento avulso
  do #018, com um campo de data editável (`showDatePicker`) — dá pra
  lançar em qualquer dia, não só no mês em exibição.
- 4 testes unitários (`get_day_ledger_test.dart`): inclui confirmada
  (diferente do check-in), exclui cancelada/adiada, inclui débito de
  fatura não paga, não duplica quando já paga.

Validado no simulador com conta real e 5 lançamentos espalhados em agosto
de 2026 (via Supabase REST, removidos ao fim): seletor de mês navegou de
Ago./26 pra Set./26 com saldo mantido em R$ 4.900,00 (soma exata dos 5
lançamentos sobre o saldo inicial — prova de que o mês seguinte carrega o
saldo corretamente sem repetir eventos); Diferença apareceu colorida
(verde no dia de entrada, vermelho no dia de saída) e o Saldo mostrou o
gradiente entre os dias; toque num dia abriu `DayDetailScreen` com o
título "8 de setembro" e o estado vazio correto. Diálogo do FAB e um dia
com itens no detalhamento não foram exercitados ponta a ponta no
simulador — automação de toque no simulador ficou pouco confiável nesta
sessão (mesmo dispositivo em que #023 e #025 já tiveram esse problema);
cobertos pelos 4 testes unitários e pela reutilização direta do diálogo
já validado do #018. Status: concluído.

### #027 — Contas removidas da UI (conta única implícita)
Depois de fechar a questão de integração bancária (`docs/adr/0006-open-finance.md`,
UPX descartado), o usuário pediu pra ir além: nenhuma gestão de "Contas"
no app — só entradas, saídas e cartão, tudo manual.

`Account` não é um detalhe de UI, é a âncora do motor de projeção
inteiro: todo `Transaction`, `RecurrenceRule` e
`CreditCard.paymentAccountId` aponta pra um `accountId`, e
`project_cashflow.dart` calcula saldo por conta antes de consolidar
(docs/CASHFLOW_ENGINE.md). Por isso a via escolhida foi a de menor risco
— **uma única conta implícita por baixo dos panos**, não remover
`Account` do domínio:

- `ensureDefaultAccount(AccountRepository)` (`accounts_providers.dart`)
  provisiona uma conta padrão (`name: 'Saldo'`, saldo inicial 0) se
  `getAll()` vier vazio — nenhuma tela pede pro usuário criar conta.
  `createAccount` virou `updateInitialBalance(cents)`, que reancora
  `initialBalanceCents`/`initialBalanceDate` em "agora" a cada edição
  (evita reconciliar retroativo).
  - ⚠️ **Bug encontrado na validação**: chamar `ensureDefaultAccount` só
    de dentro de `AccountsController.build()` não bastava —
    `GetDailyProjection` lê `AccountRepository` direto (nunca passa por
    `AccountsController`), e a Projeção é a primeira tela do app. Resultado:
    abrir o app do zero mostrava o estado vazio "Cadastre uma conta", porque
    a auto-provisão só rodava se alguma outra tela (Lançamentos, Cartões,
    Configurações) fosse aberta primeiro. Corrigido chamando
    `ensureDefaultAccount` também no boot (`main.dart`, logo após
    `configureDependencies()`), antes de `runApp` — garante que a conta
    existe antes de qualquer tela renderizar, independente de qual for a
    primeira. Validado no simulador com a tabela `accounts` vazia de
    verdade: reabrir o app cria a conta sozinho e a Projeção já mostra
    R$ 0,00 por dia, sem pedir nada.
- `AccountsScreen` deletada. Todo campo "Conta" nos diálogos de novo
  lançamento (`lancamentos_screen.dart`), novo movimento
  (`projection_screen.dart`), novo cartão (`cards_screen.dart`) e
  importar extrato (`import_screen.dart`) foi removido — usam
  `accounts.first.id` direto, sem perguntar. `accountName` parou de
  aparecer nos cards de check-in e detalhamento de dia (com 1 conta só,
  não carrega informação).
- Configurações ganhou o campo "Saldo inicial (R\$)" na seção Projeção
  (novo `_MoneyField`, mesmo padrão visual do `_NumberField` já usado
  ali) — é como o usuário corrige o saldo de partida agora que não existe
  mais tela de conta.

⚠️ **O que ficou intocado, de propósito**: `supabase/schema.sql`,
`project_cashflow.dart`, `get_daily_projection.dart`,
`get_day_ledger.dart`, `get_today_check_in_items.dart` e todos os 99
testes existentes — a engine continua recebendo exatamente a mesma forma
de dado (`List<Account>`), só que sempre com 1 item. Nenhuma migração
precisou ser escrita. Status: concluído.

### #028 — Projeção em calendário
Pedido do usuário: trocar a lista de linhas por dia por um calendário —
seleciona a data, a movimentação (entradas/saídas discriminadas) aparece
embaixo, na mesma tela, sem navegar pra outra.

Zero mudança de dado — `monthlyProjectionProvider`/`dayLedgerProvider`
(#026) já entregavam tudo, é troca de camada de apresentação:

- `projection_screen.dart` reescrita: `_MonthCalendar` (grid de 7
  colunas, hand-rolled — nenhum pacote de calendário de terceiro em
  nenhum lugar do app, mesmo padrão do seletor de mês/gradiente
  já existentes) substitui a lista de `_DayRow`. Cada célula tinge o
  fundo com `_balanceColor` (reusada sem mudança), anel âmbar em hoje,
  preenchimento âmbar no dia selecionado. Referência: Toshl/Zaim (célula
  colorida, sem valor cravado — o valor mora no painel de baixo).
- Painel de movimentação embaixo do grid absorve o que era
  `DayDetailScreen` (deletada) direto na tela — banner "Diferença do
  dia" + lista de itens, agora com ícone discriminando entrada (seta
  verde) / saída (seta vermelha). Referência: Organizze (calendário
  brasileiro mais elogiado por interface limpa — toca no dia, lança/vê
  movimento).
- FAB usa o dia selecionado direto, sem `showDatePicker` no diálogo (o
  calendário já é o seletor de data).

Status: concluído.

### #029 — Categorização de lançamentos
Ao pesquisar referências pro #028, o usuário decidiu ampliar o escopo:
"pra onde vai meu dinheiro" virou uma pergunta que a previsibilidade
sozinha não respondia (ajuste registrado em `PRODUCT.md`, não é reversão
da tese central do app).

- Novo `lib/core/utils/transaction_category.dart`: enum
  `TransactionCategory` (moradia/alimentacao/transporte/lazer/saude/
  outros — por **propósito** do gasto, não por meio de pagamento; cartão
  não é categoria) + label/ícone compartilhados entre todos os diálogos.
- Migração `supabase/migrations/0004_category.sql`: coluna `category
  text not null default 'outros'` em `transactions`, `recurrence_rules`
  e `invoice_items` — mesmo padrão de `is_variable` (#018), sem quebrar
  linha existente. ⚠️ Precisa ser aplicada manualmente no SQL Editor do
  Supabase antes de funcionar contra dado real (mesma limitação das
  migrações 0002/0003 — Claude não tem acesso de DDL).
- `Transaction`, `RecurrenceRule`, `InvoiceItem`, `CheckInItem` ganham
  `category` (default `outros`); `RegisterCardPurchase` ganha o
  parâmetro. Dropdown de categoria nos diálogos de novo lançamento
  (`lancamentos_screen.dart`), novo movimento (`projection_screen.dart`)
  e nova compra de cartão (`card_detail_screen.dart`).
- `summarizeMonth` (`monthly_summary.dart`) ganha `categoryCents` — mesma
  iteração que já compõe `costOfLivingCents` (saídas de conta + gasto de
  cartão, excluindo pagamento de fatura), só bucketada por categoria em
  vez de somada num total; a soma dos valores bate com
  `costOfLivingCents` (testado). Novo card "Gastos por categoria" na aba
  Mês (`month_screen.dart`), ordenado decrescente, barra de % por linha.

Status: concluído no código; migração pendente de aplicação manual.

### #030 — Guia 50/30/20, plano de quitação de fatura atrasada e meta de reserva sugerida
Três estratégias de educação financeira escolhidas pelo usuário (dentre
opções levantadas com pesquisa web) pra ajudar a "ficar no azul e deixar
de depender do cartão de crédito" — motivação original do produto.

- **Guia 50/30/20**: `budget503020(MonthlySummary)`
  (`monthly_summary.dart`) — necessidades (moradia/alimentação/
  transporte/saúde) e desejos (o resto de `categoryCents`, por
  subtração, não por um segundo conjunto explícito) vêm da categorização
  do #029; reserva reusa `savedCents`/`savingsPercent` já calculados
  (⚠️ mesma limitação do #021: sobra do mês, não aporte real em
  `Reserve`, que não tem ledger). Card novo na aba Mês, 3 linhas com
  barra comparando % real à meta.
- **Plano de quitação de fatura atrasada**: novo
  `GetOverdueCardDebt` (`credit_cards/domain/usecases/`) — mesmo padrão
  de `GetCommittedCardBalance` (#024), mas soma só fatura com `dueDate`
  **no passado** e não paga (rotativo de verdade, não só "em aberto").
  Card condicional na aba Mês (só aparece com dívida atrasada): valor
  atrasado ÷ 3 meses (horizonte fixo, ponytail: MVP) = quanto pagar a
  mais por mês pra zerar.
- **Meta de reserva sugerida**: diálogo de nova reserva
  (`reserves_screen.dart`) ganha 2 chips ("3x custo de vida" / "6x") que
  preenchem o campo Meta ao tocar, usando `monthlySummaryProvider` já
  existente — sem use case novo.

Status: concluído.

### #031 — Sugestões de IA sobre gastos (opt-in, sob demanda)
Pedido do usuário: avaliar integrar um modelo de IA que analise entradas/
gastos e sugira redução de despesa e melhora de economia, com pesquisa de
estudos/artigos de apoio. Decisão registrada em `docs/adr/0007-ai-insights.md`
(distinção explícita da ADR 0006, que rejeitou acesso automático de
terceiro a dado bancário bruto — isto é sob comando explícito do usuário
e só dado agregado).

- **Edge Function** `supabase/functions/financial-insights/index.ts`
  (Deno) — recebe o resumo agregado do mês, chama a API da Anthropic
  (`claude-haiku-4-5`) com prompt que proíbe recalcular qualquer valor
  (mesmo princípio de "confiança em dinheiro" do resto do app), devolve
  3 sugestões em português como array JSON. `ANTHROPIC_API_KEY` como
  secret do Supabase, nunca no client. ⚠️ Precisa ser deployada
  manualmente (`supabase functions deploy financial-insights` +
  `supabase secrets set ANTHROPIC_API_KEY=...`) — Claude não tem acesso
  de deploy, mesma categoria das migrações pendentes.
- **`lib/features/insights/`** (domain/data/presentation): `FinancialInsights`
  (entity), `InsightsRepository`/`InsightsRepositoryImpl` (chama
  `supabase.functions.invoke`, guardDatabase), `GenerateFinancialInsights`
  (use case), `InsightsController` (Riverpod, estado só em memória —
  ponytail: sem tabela de cache, MVP). Payload: `categoryCents` (rótulo
  via `categoryLabel`, sem descrição de lançamento), saída de
  `budget503020`, `savedCents`/`savingsPercent`, dívida atrasada de
  `GetOverdueCardDebt` — tudo já calculado, nada recomputado.
- **Opt-in em Configurações**: `SwitchListTile` "Sugestões por IA"
  (mesmo padrão do toggle de notificações do #022), desligado por
  padrão. Card novo na aba Mês só oferece o botão "Gerar sugestões"
  quando ligado; desligado, mostra convite mudo pra ativar.

Status: concluído no código; deploy da Edge Function pendente (manual).

### #032 — Lembretes por WhatsApp (Evolution API)
Pedido do usuário: lembretes por WhatsApp de contas a vencer, pagamento
de fatura de cartão e um relatório periódico da situação financeira do
casal, via Evolution API (gateway self-hosted de WhatsApp). Decisão
registrada em `docs/adr/0008-whatsapp-reminders.md` — diferente da 0006/
0007, aqui não há terceiro recebendo dado: a Evolution API é hospedada
pelo próprio usuário e o destino é o próprio WhatsApp do casal, então
não há toggle de opt-in novo (o deploy manual já é o gate).

- **Edge Function** `supabase/functions/whatsapp-reminders/index.ts`
  (Deno), disparada 1x/dia via `pg_cron`. Porta uma versão de
  `expandRecurrence` (`recurrence_expansion.dart`) pro TypeScript —
  segunda implementação da mesma regra de data, assumida
  conscientemente (comentário aponta o arquivo Dart como fonte da
  verdade). Dois blocos:
  - **Contas a vencer** (todo dia): junta lançamentos avulsos
    `previsto`, ocorrências de `recurrence_rules` que caem exatamente
    `ADVANCE_NOTICE_DAYS` (3) dias à frente, e faturas de cartão não
    pagas vencendo nesse dia — dispara 1 mensagem só se achar algo.
    Idempotente por checar o dia exato, não uma janela (limitação:
    falha do cron nesse dia perde o lembrete, sem reenvio).
  - **Relatório semanal** (só segundas): versão enxuta de
    `summarizeMonth` (sem quebra por categoria, evita depender da
    migração 0004) — entradas, saídas, economia e fatura atrasada do
    mês corrente.
  - Envio via `POST {EVOLUTION_API_URL}/message/sendText/{EVOLUTION_INSTANCE}`
    (header `apikey`), pra cada número em
    `WHATSAPP_PHONE_1`/`WHATSAPP_PHONE_2`.
- **Migração** `supabase/migrations/0005_whatsapp_reminders.sql`:
  habilita `pg_cron`/`pg_net` e agenda a chamada diária via
  `net.http_post` (placeholders de project ref/anon key — nenhum dos
  dois é segredo — a preencher antes de rodar).
- **Zero mudança em `lib/`** — números de WhatsApp e credenciais da
  Evolution API são só secrets do Supabase, sem tela nova.

⚠️ **Você precisa fazer manualmente**: hospedar uma instância Evolution
API e parear o WhatsApp via QR code; `supabase functions deploy
whatsapp-reminders`; `supabase secrets set EVOLUTION_API_URL=...
EVOLUTION_API_KEY=... EVOLUTION_INSTANCE=... WHATSAPP_PHONE_1=...
WHATSAPP_PHONE_2=...`; editar os placeholders e rodar a migração 0005 no
SQL Editor.

Status: concluído no código; deploy da Evolution API + Edge Function +
migração pendente (manual).

## Backlog (fora da ordem atual — decisões já tomadas, implementação adiada)

Discutido e decidido em sessão, mas propositalmente adiado até M0–M6
estarem prontos, para ter mais base construída antes de atacar isso:

- **Open Finance**: avaliado e adiado (pesquisa registrada na sessão que
  criou o M7). Acesso direto exige autorização do Banco Central (Resolução
  Conjunta 1/2020, art. 6º) — inviável pra app doméstico sem CNPJ.
  Agregadores (Pluggy, Belvo) resolvem sem licença própria, mas exigem
  CNPJ, contrato e mensalidade. O servidor `banco-mcp`
  (github.com/douglac/banco-mcp) não serve pra este caso: é um servidor
  MCP pra Claude/Cursor, não uma biblioteca consumível pelo app Flutter, e
  trafegaria dado bancário por um provedor de LLM. Caminho fica sendo
  OFX/CSV (item acima); revisitar com um ADR próprio se o app crescer pra
  fora do uso doméstico.
- **Gráficos**: sem escopo definido ainda (de quê? saldo ao longo do
  tempo, fatura por mês?) — decidir junto com o desenho das telas de M6.
