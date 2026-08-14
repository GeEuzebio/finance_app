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

## Backlog (fora da ordem atual — decisões já tomadas, implementação adiada)

Discutido e decidido em sessão, mas propositalmente adiado até M0–M6
estarem prontos, para ter mais base construída antes de atacar isso:

- **Importação de extrato/fatura**: começar por OFX/CSV (formato
  estruturado, a maioria dos bancos brasileiros exporta), não PDF — PDF de
  fatura não tem layout padronizado entre bancos, viraria um parser por
  banco que quebra a cada mudança de layout. PDF só entra como fase futura
  se OFX/CSV não for suficiente.
- **Análise de risco financeiro**: definido pelo usuário como a mescla de
  duas coisas, ambas computáveis com o que já existe, sem reabrir
  categorização de gasto (decisão original do produto):
  1. Alertas de saldo previsto negativo em dias futuros — a engine já
     calcula isso (`docs/CASHFLOW_ENGINE.md` caso de teste #9); só falta
     expor com destaque numa tela (M6, #014).
  2. "Saldo comprometido com fatura de cartão em aberto" — quanto do saldo
     disponível hoje já está "gasto" por compras feitas no cartão que
     ainda não foram debitadas da conta. Computável a partir de
     `CreditCardRepository.totalCentsForInvoice` somado sobre as faturas
     abertas de cada cartão — é uma extensão natural do conceito de
     "saldo livre" que reservas já usam (`docs/CASHFLOW_ENGINE.md` §3,
     Reservas), não uma feature nova de categorização.
- **Gráficos**: sem escopo definido ainda (de quê? saldo ao longo do
  tempo, fatura por mês?) — decidir junto com o desenho das telas de M6.
