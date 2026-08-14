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
cônjuge) em um único banco de dados compartilhado — sem login, sem seleção
de perfil. Contas têm um dono (`owner`) só para fins de exibição e filtro;
a projeção é sempre uma única visão consolidada da casa.

⚠️ Persistência via Supabase/Postgres (ADR 0005, supersede ADR 0002 —
local Drift/SQLite). Isso resolve o requisito de ver os mesmos dados nos
dois aparelhos sem sync manual, mas troca o pilar original "100%
offline-first, sem backend" por um app que exige conexão — não há mais
modo offline nem fallback local nesta versão.

## 2. Camadas e regra de importação

```
presentation  →  domain  ←  data
```

- **domain**: entidades puras (Dart puro, sem Flutter, sem Supabase), regras
  de negócio, casos de uso (classes `UseCase`), contratos de repositório
  (interfaces abstratas) e a engine de projeção. Não importa `data` nem
  `presentation`. Não importa `supabase_flutter`, `flutter` ou `riverpod`.
- **data**: implementações concretas dos contratos de `domain`
  (repositórios), mapeamento JSON (`Map<String, dynamic>` do Postgrest) ↔
  entidade, tratamento de exceções → `Failure`. Importa `domain` (para
  implementar os contratos) e `supabase_flutter`. Nunca importa
  `presentation`.
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
      guard_database.dart            # try/catch -> Either<Failure, T> compartilhado
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
        repositories/account_repository_impl.dart   # também expõe accountFromJson/accountToJson
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
**Não é uma tabela persistida.** É o tipo de retorno em memória da função pura de
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

## 5. Schema Postgres (Supabase)

Uma tabela por entidade persistida (todas exceto `DailyBalance`), definida
em SQL puro em [`supabase/schema.sql`](../supabase/schema.sql) — não há
mais schema Dart gerado (ver ADR 0005, que substitui o ADR 0002/Drift).
Convenções: chave primária `uuid default gen_random_uuid()`; enums como
tipos nativos do Postgres (`create type ... as enum (...)`), com os mesmos
valores dos enums Dart (`AccountType.checking.name == 'checking'`, sem
tabela de tradução); dinheiro sempre `bigint` (centavos); datas de
lançamento `date` (sem hora — mapeia direto para `DateOnly` no Dart, sem
truncagem manual); `created_at`/`updated_at` como `timestamptz`.

Colunas em `snake_case` (convenção Postgres) ↔ campos `camelCase` na
entidade Dart — o mapeamento fica nas próprias implementações de
repositório (`accountFromJson`/`accountToJson` etc., funções puras
testáveis sem rede, uma por entidade).

`Invoice.totalCents` continua **não** sendo uma coluna: cada
`CreditCardRepositoryImpl.totalCentsForInvoice` soma `amount_cents` dos
itens da fatura no cliente (ponytail: volume por fatura é pequeno; migrar
para uma view/RPC agregada no Postgres só se isso crescer).

Segurança: sem autenticação nesta versão, RLS fica **ligado** em todas as
tabelas com uma política permissiva (`using (true)`) por tabela — acesso da
`SUPABASE_ANON_KEY` é total na prática, mas RLS ligado é o padrão
recomendado pelo Supabase e deixa pronto o caminho para apertar a política
por usuário se o app ganhar login (documentado com `⚠️` no topo do
`schema.sql`). A `SUPABASE_SERVICE_ROLE_KEY` nunca é referenciada em `lib/`.

### Estratégia de migrations

Um arquivo SQL novo por mudança de schema, nunca editar um já aplicado —
mesma disciplina que o Drift já seguia, só que aplicada manualmente no SQL
Editor do Supabase (sem CLI/Docker configurados nesta sessão). ⚠️
SUPOSIÇÃO: adotar o Supabase CLI (`supabase migration new`) fica para
quando o time quiser CI/CD de schema — hoje é um passo manual documentado.

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
- `DatabaseFailure`: qualquer exceção do cliente Supabase/Postgrest capturada no
  boundary `data` (constraint violation, disco cheio, etc.) — nunca vaza
  `SqliteException` além da camada `data`.
- `ProjectionFailure`: engine recebeu entrada inconsistente (ex.: regra de
  recorrência com `endDate` antes de `startDate`) — reservado para falhas de
  invariante, não para "0 lançamentos" (isso é um resultado válido, lista
  vazia, não uma falha).

`data` layer sempre captura exceptions de infraestrutura em `try/catch` e
converte para `Left(DatabaseFailure(...))`; `domain`/`presentation` nunca
fazem `try/catch` de exception de infraestrutura — só tratam `Either`.
