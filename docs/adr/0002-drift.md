# ADR 0002 — Persistência local com Drift

## Contexto
Produto 100% offline-first, sem backend na v1. A persistência precisa
suportar: schema relacional com foreign keys reais (Transaction → Account,
InvoiceItem → Invoice, etc.), migrations versionadas conforme o produto
evolui (novas colunas/tabelas a cada milestone do roadmap), e queries
agregadas testáveis sem depender de Flutter widgets (ex.: `SUM(amountCents)`
para o total de uma fatura, streams reativas para os providers Riverpod).

## Decisão
Drift (SQLite + geração de código type-safe) como única camada de
persistência local.

## Consequências
- Schema definido em Dart (`Table` classes, ver `docs/ARCHITECTURE.md` §5),
  compilado para SQL real via `drift_dev` — erros de coluna/tipo pegos em
  build time, não em runtime.
- Migrations via `MigrationStrategy.onUpgrade` com `schemaVersion`
  incremental — cada mudança de schema é uma migration nova, nunca uma
  edição de migration já publicada.
- DAOs Drift ficam inteiramente na camada `data`; `domain` só conhece as
  entidades puras e as interfaces de `Repository` — Drift nunca vaza para
  `domain` ou `presentation` (regra de importação do ADR arquitetural).
- Queries agregadas (soma de fatura, saldo consolidado) podem ser feitas em
  SQL puro via Drift quando fizer sentido, evitando reimplementar agregação
  em Dart para dados que já estão no banco.
- `sqlite3_flutter_libs` traz o binário SQLite para Android/iOS sem
  configuração nativa manual.

## Alternativas descartadas
- **Isar**: mais rápido para alguns padrões de leitura, mas sem SQL real —
  agregações e joins (fatura ↔ itens ↔ conta) ficariam mais verbosos em
  Dart puro; ecossistema menor para migrations versionadas complexas.
- **sqflite puro** (sem geração de código): sem type-safety em queries,
  SQL como string solta — maior risco de erro silencioso e mais difícil de
  testar isoladamente sem widget/plugin bindings.
- **Hive**: banco chave-valor, não relacional — não suporta bem o grafo de
  relações do domínio (Account → Transaction → RecurrenceRule,
  CreditCard → Invoice → InvoiceItem) nem queries agregadas nativas.
- **ObjectBox**: licença e modelo de objeto proprietário; equipe não tem
  motivo para abrir mão de SQL padrão, que facilita debug manual do banco
  (`sqlite3` CLI) durante desenvolvimento.
