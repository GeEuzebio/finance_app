# Arquitetura

> Documento de arquitetura do app de finanças preditivas. Escopo: estrutura de
> camadas, entidades de domínio, schema de persistência e catálogo de erros.
> Não descreve nenhuma tela, widget ou fluxo de UI — ver `docs/ROADMAP.md`
> para o planejamento de features futuras.

## 1. Contexto do produto

O diferencial do produto é **previsibilidade**, não categorização do passado.
A pergunta que o app responde é "quanto eu vou ter no banco no dia X",
calculada por uma engine de projeção diária pura (ver
`docs/CASHFLOW_ENGINE.md`). Quatro pilares guiam toda decisão de modelagem:
projeção diária, check-in diário, gestão de cartões e reservas/objetivos.

Uso do app: pessoal, compartilhado entre duas pessoas (o usuário e o
cônjuge) em um único banco de dados local no aparelho — sem login, sem
seleção de perfil. Contas têm um dono (`owner`) só para fins de exibição e
filtro; a projeção é sempre uma única visão consolidada da casa.

100% offline-first, sem backend na v1.

## 2. Camadas e regra de importação

```
presentation  →  domain  ←  data
```

- **domain**: entidades puras (Dart puro, sem Flutter, sem Drift), regras de
  negócio, casos de uso (classes `UseCase`), contratos de repositório
  (interfaces abstratas) e a engine de projeção. Não importa `data` nem
  `presentation`. Não importa `drift`, `flutter` ou `riverpod`.
- **data**: implementações concretas dos contratos de `domain` (repositórios),
  DAOs Drift, mapeamento entidade ↔ tabela, tratamento de exceções → `Failure`.
  Importa `domain` (para implementar os contratos) e pacotes de
  infraestrutura (`drift`, `sqlite3`). Nunca importa `presentation`.
- **presentation**: widgets, providers Riverpod, controllers/notifiers.
  Importa `domain` (casos de uso, entidades) via DI. Nunca importa `data`
  diretamente — sempre through the domain layer contracts resolvidos pelo
  `get_it`.

Regra de importação enforced por convenção de diretório + revisão manual
(v1 não usa lint customizado para isso — ⚠️ SUPOSIÇÃO: `import_lint` ou
pacotes similares de enforcement automático ficam para uma versão futura,
YAGNI enquanto o time é pequeno).

Fluxo de dependência em runtime: `presentation` pede uma instância ao
`get_it` (registrada via `injectable`), que entrega a implementação de
`data` por trás da interface de `domain`. `presentation` nunca instancia
`data` diretamente.

## 3. Árvore de diretórios oficial

```
lib/
  core/
    di/
      injection.dart
      injection.config.dart          # gerado (injectable_generator)
    errors/
      failure.dart                   # hierarquia de Failure (seção 6)
    database/
      app_database.dart              # @DriftDatabase, tabelas + migrations
      app_database.g.dart            # gerado (drift_dev)
      connection.dart                # abertura da conexão nativa sqlite3
      tables/
        accounts_table.dart
        transactions_table.dart
        recurrence_rules_table.dart
        credit_cards_table.dart
        invoices_table.dart
        invoice_items_table.dart
        reserves_table.dart
    utils/
      money.dart                     # helpers de int-centavos (soma, formatação)
      date_only.dart                 # tipo/helpers de data sem hora (America/Sao_Paulo)
  features/
    accounts/
      domain/
        entities/account.dart
        repositories/account_repository.dart      # interface
        usecases/...
      data/
        models/account_dto.dart                    # mapeamento Drift row ↔ entidade
        repositories/account_repository_impl.dart
        datasources/account_local_datasource.dart   # usa AccountsDao
      presentation/                                 # fora de escopo nesta sessão
    transactions/
      domain/
        entities/transaction.dart
        entities/recurrence_rule.dart
        repositories/transaction_repository.dart
        repositories/recurrence_repository.dart
        usecases/...
      data/...
      presentation/                                 # fora de escopo
    credit_cards/
      domain/
        entities/credit_card.dart
        entities/invoice.dart
        entities/invoice_item.dart
        repositories/credit_card_repository.dart
        usecases/...
      data/...
      presentation/                                 # fora de escopo
    reserves/
      domain/
        entities/reserve.dart
        repositories/reserve_repository.dart
        usecases/...
      data/...
      presentation/                                 # fora de escopo
    cashflow_engine/
      domain/
        entities/daily_balance.dart      # não persistido, ver seção 4
        project_cashflow.dart            # função pura — ver CASHFLOW_ENGINE.md
      data/                               # não aplicável — engine não faz I/O
  main.dart
test/
  core/
    database/app_database_test.dart
    di/injection_test.dart
  features/
    cashflow_engine/
      project_cashflow_test.dart          # os ≥12 casos de CASHFLOW_ENGINE.md
    ...
```

Cada `feature/*` segue o mesmo tripé `domain/data/presentation`, mesmo que
`presentation` fique vazio nesta sessão — a pasta existe para a próxima
sessão não precisar decidir estrutura de novo.

## 4. Entidades de domínio

Todos os valores monetários são `int` (centavos). Todas as datas de
lançamento são "date-only" (sem hora), fuso `America/Sao_Paulo`, representadas
por um tipo `DateOnly` (wrapper leve sobre `DateTime` truncado à meia-noite —
ver `core/utils/date_only.dart`).

### Account
| campo | tipo | observação |
|---|---|---|
| id | `String` (uuid) | |
| name | `String` | |
| type | `AccountType` (enum: `checking`, `savings`, `wallet`, `other`) | |
| owner | `AccountOwner` (enum: `eu`, `conjuge`, `conjunta`) | decisão de sessão — casal compartilha 1 banco |
| initialBalanceCents | `int` | saldo conciliado no `initialBalanceDate` |
| initialBalanceDate | `DateOnly` | ponto de partida da projeção (§ Projeção) |
| archived | `bool` | contas arquivadas saem da projeção mas mantêm histórico |
| createdAt | `DateTime` | |

### Transaction
| campo | tipo | observação |
|---|---|---|
| id | `String` (uuid) | |
| accountId | `String` (FK Account) | |
| description | `String` | |
| amountCents | `int` (signed) | positivo = crédito, negativo = débito |
| date | `DateOnly` | |
| status | `TransactionStatus` (enum: `previsto`, `confirmado`, `ajustado`, `adiado`, `cancelado`) | ver máquina de estados em CASHFLOW_ENGINE.md |
| recurrenceRuleId | `String?` (FK RecurrenceRule) | null = lançamento pontual |
| originalTransactionId | `String?` (self FK) | preenchido quando `status` é `ajustado`/`adiado`, aponta pra ocorrência original |
| transferGroupId | `String?` (uuid) | liga o par débito/crédito de uma transferência entre contas próprias |
| invoicePaymentForId | `String?` (FK Invoice) | preenchido quando esta transação é o pagamento de uma fatura |
| createdAt / updatedAt | `DateTime` | |

### RecurrenceRule
| campo | tipo | observação |
|---|---|---|
| id | `String` (uuid) | |
| accountId | `String` (FK Account) | |
| description | `String` | |
| amountCents | `int` (signed) | |
| frequency | `RecurrenceFrequency` (enum: `weekly`, `monthly`, `yearly`, `custom`) | |
| interval | `int` | a cada N unidades da `frequency` (ex.: `monthly` + `interval=2` = bimestral); para `custom`, N dias |
| startDate | `DateOnly` | |
| endDate | `DateOnly?` | mutuamente exclusivo com `occurrenceCount` |
| occurrenceCount | `int?` | mutuamente exclusivo com `endDate`; null+null = infinita |
| createdAt | `DateTime` | |

### CreditCard
| campo | tipo | observação |
|---|---|---|
| id | `String` (uuid) | |
| name | `String` | |
| paymentAccountId | `String` (FK Account) | conta debitada quando a fatura é paga |
| closingDay | `int` (1–31) | dia de fechamento do ciclo |
| dueDay | `int` (1–31) | dia de vencimento |
| limitCents | `int?` | opcional, informativo — v1 não bloqueia compra acima do limite |
| owner | `AccountOwner` | mesmo enum de `Account.owner` |
| createdAt | `DateTime` | |

### Invoice
| campo | tipo | observação |
|---|---|---|
| id | `String` (uuid) | |
| creditCardId | `String` (FK CreditCard) | |
| referenceMonth | `String` (`YYYY-MM`) | mês de referência da fatura |
| closingDate | `DateOnly` | derivada de `closingDay`, mas persistida (feriado/mês curto já resolvido no momento da geração) |
| dueDate | `DateOnly` | derivada de `dueDay` — sem ajuste automático de fim de semana (⚠️ SUPOSIÇÃO, ver CASHFLOW_ENGINE.md) |
| totalCents | `int` | computado = soma de `InvoiceItem` ativos da fatura |
| status | `InvoiceStatus` (enum: `aberta`, `fechada`, `paga`) | |
| createdAt | `DateTime` | |

### InvoiceItem
| campo | tipo | observação |
|---|---|---|
| id | `String` (uuid) | |
| invoiceId | `String` (FK Invoice) | fatura em que esta parcela/compra cai |
| description | `String` | |
| amountCents | `int` (signed) | negativo = compra normal, positivo = estorno (§ Cartão) |
| purchaseDate | `DateOnly` | data real da compra (não a data da fatura) |
| installmentNumber | `int` | 1-based |
| installmentTotal | `int` | 1 para compra à vista |
| purchaseGroupId | `String` (uuid) | liga todas as parcelas da mesma compra |
| createdAt | `DateTime` | |

### Reserve
| campo | tipo | observação |
|---|---|---|
| id | `String` (uuid) | |
| name | `String` | |
| targetAmountCents | `int?` | meta opcional |
| currentAmountCents | `int` | valor já reservado |
| createdAt | `DateTime` | |

⚠️ SUPOSIÇÃO: `Reserve` é transversal (recorte lógico sobre o saldo
consolidado), não presa a uma `Account` específica. Justificativa: mais
simples de implementar e mais flexível para o usuário (ex.: "reserva de
emergência" não precisa estar fisicamente separada em uma conta poupança).

### DailyBalance
**Não é uma tabela Drift.** É o tipo de retorno em memória da função pura de
projeção (`project_cashflow.dart`), recalculado sob demanda a cada chamada
(orçamento de performance: <50ms para 12 meses / 500 lançamentos — ver
CASHFLOW_ENGINE.md). Nunca persistido, para não ter que invalidar cache toda
vez que um lançamento muda.

| campo | tipo | observação |
|---|---|---|
| date | `DateOnly` | |
| accountId | `String?` | null = projeção consolidada de todas as contas |
| openingBalanceCents | `int` | saldo ao abrir o dia (= closing do dia anterior) |
| closingBalanceCents | `int` | saldo ao fechar o dia |
| projectedCreditsCents | `int` | soma de créditos do dia |
| projectedDebitsCents | `int` | soma de débitos do dia |
| freeBalanceCents | `int` | `closingBalanceCents` − Σ reservas ativas (só faz sentido no consolidado, já que `Reserve` não é por conta) |

## 5. Schema Drift

Uma tabela Drift por entidade persistida (todas exceto `DailyBalance`).
Convenções: chave primária `TextColumn id` (uuid gerado em Dart, não
autoincrement — evita colisão entre inserts client-side antes do sync futuro,
caso venha a existir); enums mapeados via `TextColumn().map(EnumIndexConverter)`
ou `intEnum` do drift; dinheiro sempre `IntColumn` (centavos); datas de
lançamento `DateTimeColumn` truncadas para meia-noite America/Sao_Paulo no
momento da escrita (o tipo `DateOnly` do domínio cuida da truncagem antes de
chegar no DAO).

```dart
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get type => intEnum<AccountType>()();
  IntColumn get owner => intEnum<AccountOwner>()();
  IntColumn get initialBalanceCents => integer()();
  DateTimeColumn get initialBalanceDate => dateTime()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get status => intEnum<TransactionStatus>()();
  TextColumn get recurrenceRuleId =>
      text().nullable().references(RecurrenceRules, #id)();
  TextColumn get originalTransactionId => text().nullable()();
  TextColumn get transferGroupId => text().nullable()();
  TextColumn get invoicePaymentForId =>
      text().nullable().references(Invoices, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class RecurrenceRules extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();
  IntColumn get frequency => intEnum<RecurrenceFrequency>()();
  IntColumn get interval => integer()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get occurrenceCount => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class CreditCards extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get paymentAccountId => text().references(Accounts, #id)();
  IntColumn get closingDay => integer()();
  IntColumn get dueDay => integer()();
  IntColumn get limitCents => integer().nullable()();
  IntColumn get owner => intEnum<AccountOwner>()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Invoices extends Table {
  TextColumn get id => text()();
  TextColumn get creditCardId => text().references(CreditCards, #id)();
  TextColumn get referenceMonth => text()();
  DateTimeColumn get closingDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get status => intEnum<InvoiceStatus>()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
  // totalCents não é coluna: é agregado via query (SUM) sobre InvoiceItems.
}

class InvoiceItems extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceId => text().references(Invoices, #id)();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();
  DateTimeColumn get purchaseDate => dateTime()();
  IntColumn get installmentNumber => integer()();
  IntColumn get installmentTotal => integer()();
  TextColumn get purchaseGroupId => text()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Reserves extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get targetAmountCents => integer().nullable()();
  IntColumn get currentAmountCents => integer()();
  DateTimeColumn get createdAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}
```

`Invoice.totalCents` é deliberadamente **não** uma coluna: é sempre derivado
via `SUM(amountCents)` sobre `InvoiceItems` da fatura, para nunca dessincronizar
do detalhe (estorno, nova compra) — ponytail: uma coluna cacheada exigiria
um trigger ou recomputo manual em todo write; a query agregada é mais barata
de manter certa do que de manter sincronizada.

### Estratégia de migrations

`schemaVersion` incremental (`int`, começa em 1). Cada versão nova =
`schemaVersion++` + um step em `MigrationStrategy.onUpgrade` usando
`stepByStep` do drift (`m.addColumn`, `m.createTable`, etc., um `case` por
transição de versão `from → to`). Nunca editar uma migration já publicada —
sempre uma nova. Testado via `verifySelfConsistency` do drift em CI
(⚠️ SUPOSIÇÃO: convenção padrão do pacote, não uma decisão específica deste
produto).

## 6. Catálogo de Failures

Hierarquia própria (não usa exceptions do Dart além do boundary
data↔domain). Toda `Repository` do domínio retorna `Either<Failure, T>`
(fpdart). `Failure` é uma classe base selada (`sealed class`).

```dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {this.cause});
  final Object? cause;
}

class ProjectionFailure extends Failure {
  const ProjectionFailure(super.message);
}
```

- `ValidationFailure`: dados de entrada inválidos antes de chegar no banco
  (ex.: `closingDay` fora de 1–31, `installmentTotal < 1`).
- `NotFoundFailure`: busca por id que não existe (ex.: editar `Transaction`
  inexistente).
- `DatabaseFailure`: qualquer exceção do driver sqlite/drift capturada no
  boundary `data` (constraint violation, disco cheio, etc.) — nunca vaza
  `SqliteException` além da camada `data`.
- `ProjectionFailure`: engine recebeu entrada inconsistente (ex.: regra de
  recorrência com `endDate` antes de `startDate`) — reservado para falhas de
  invariante, não para "0 lançamentos" (isso é um resultado válido, lista
  vazia, não uma falha).

`data` layer sempre captura exceptions de infraestrutura em `try/catch` e
converte para `Left(DatabaseFailure(...))`; `domain`/`presentation` nunca
fazem `try/catch` de exception de infraestrutura — só tratam `Either`.
