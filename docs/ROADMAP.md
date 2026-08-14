# Roadmap

> Milestones e issues numeradas. Issues de M0–M5 (domínio + dados) estão
> detalhadas o suficiente para implementação direta. Issues de M6 (telas)
> são apenas títulos/objetivo de alto nível — fora do escopo desta sessão de
> arquitetura, sem código de feature/widget produzido aqui.

## M0 — Fundação

### #001 — Setup do core + DI + camada base
Objetivo: estrutura mínima do projeto compilando, com DI e conexão de banco
funcionando, sem nenhuma tabela de feature ainda.
Ver especificação completa em `docs/issues/0001-setup-core.md`.
Dependências: nenhuma.

### #002 — Schema Drift completo
Objetivo: criar as 7 tabelas de `docs/ARCHITECTURE.md` §5
(`Accounts`, `Transactions`, `RecurrenceRules`, `CreditCards`, `Invoices`,
`InvoiceItems`, `Reserves`) e a migration inicial (`schemaVersion = 1`).
Critérios de aceite:
- Todas as 7 tabelas existem exatamente como especificado em ARCHITECTURE.md.
- `AppDatabase` abre em memória em teste sem erro.
- Foreign keys ativas (`PRAGMA foreign_keys = ON`) e testadas (insert com FK
  inválida falha).
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
Dart puro (sem Flutter, sem Drift).
Critérios de aceite:
- Campos e tipos batem exatamente com `docs/ARCHITECTURE.md` §4.
- Nenhum import de `flutter`, `drift` ou `riverpod` nesses arquivos.
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

### #007 — DAOs Drift
Objetivo: um DAO por tabela (`AccountsDao`, `TransactionsDao`, ...) com as
queries necessárias, incluindo a agregação `SUM(amountCents)` por
`invoiceId` para `Invoice.totalCents`.
Critérios de aceite:
- Cada DAO testado contra banco em memória (insert/update/delete/query).
- Query agregada de fatura testada com múltiplos itens + estorno.
Dependências: #002.

### #008 — Repositórios
Objetivo: implementar os contratos `XRepository` de `domain` na camada
`data`, mapeando `Transaction`/exceções do Drift para `Either<Failure, T>`.
Critérios de aceite:
- Nenhuma exception de Drift/sqlite escapa da camada `data` — tudo vira
  `Left(DatabaseFailure(...))` no boundary.
- Um `XRepositoryImpl` por entidade persistida, anotado
  `@LazySingleton(as: XRepository)`.
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

## M6 — Superfícies de produto (fora de escopo desta sessão)

Títulos apenas, sem detalhamento — dependem de uma sessão de UI/UX futura:

- #014 — Tela de projeção diária (pilar 1)
- #015 — Tela de Check-in Diário (pilar 2)
- #016 — Tela de gestão de cartões (pilar 3)
- #017 — Tela de reservas e objetivos (pilar 4)

Dependências: toda a M0–M5.
