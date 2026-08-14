# ADR 0005 — Persistência compartilhada com Supabase

## Contexto
O ADR 0002 fixou Drift/SQLite local como persistência, sob a premissa de um
app 100% offline-first sem backend (decisão original da sessão de
arquitetura). Na prática, o uso real do produto é compartilhado entre duas
pessoas (usuário e cônjuge) em aparelhos diferentes, olhando o mesmo
conjunto de contas, lançamentos e faturas (`docs/ARCHITECTURE.md` §1). Um
banco SQLite local por aparelho não resolve isso — cada um veria seus
próprios dados, sem nenhum jeito de sincronizar sem construir uma camada de
sync própria (conflitos, merge, fila offline). Diante disso, o produto
trocou "offline-first sem backend" por "um banco compartilhado na nuvem",
aceitando que o app passa a exigir conexão.

## Decisão
Supabase (Postgres gerenciado + client Dart oficial `supabase_flutter`)
como única fonte de dados do app, substituindo inteiramente o Drift. Sem
autenticação nesta versão: as duas pessoas usam a mesma
`SUPABASE_ANON_KEY`. RLS fica **ligado** em todas as tabelas com uma
política permissiva (`using (true)`) por tabela — mesmo acesso que RLS
desligado teria, mas seguindo o padrão recomendado pelo Supabase e com o
caminho pronto para apertar por usuário se o app ganhar login um dia
(documentado em `supabase/schema.sql` e `supabase/policies.sql`).

## Consequências
- O pilar "100% offline-first" do produto não existe mais — o app não
  funciona sem internet, e não há cache/fila local de escrita pendente
  nesta versão (fora de escopo; poderia ser adicionado depois com Drift
  como cache local + Supabase como fonte de verdade, mas isso é uma
  arquitetura bem mais complexa e não foi pedida agora).
- Todo o schema (`docs/ARCHITECTURE.md` §5) virou SQL puro em
  `supabase/schema.sql`, aplicado manualmente no SQL Editor do Supabase —
  não há mais migrations geradas por `drift_dev`.
- As implementações de repositório (`data/repositories/*_impl.dart`)
  trocaram DAOs Drift por chamadas diretas ao `SupabaseClient`
  (`.from(tabela).select()/.upsert()/.delete()`), mapeando
  `Map<String, dynamic>` (JSON do Postgrest) ↔ entidade. O contrato de
  domínio (`Either<Failure, T>`) não mudou — só a implementação por trás.
- `guardDatabase` (`core/errors/guard_database.dart`) continua sendo o
  único ponto que captura exceções de infraestrutura e as converte em
  `Left(DatabaseFailure(...))` — agora captura `PostgrestException` em vez
  de `SqliteException`, sem mudar a assinatura nem o resto do código que
  já dependia dele.
- Testes de repositório deixaram de rodar contra um banco em memória (não
  existe mais) e passaram a testar só as funções puras de mapeamento
  (`xFromJson`/`xToJson`), sem rede. Não há teste de integração real contra
  o Supabase nesta sessão — nenhuma ferramenta local (Supabase CLI) estava
  disponível no ambiente. ⚠️ SUPOSIÇÃO/gap conhecido: se o time instalar o
  Supabase CLI + Docker (Docker já está disponível na máquina), dá para
  rodar `supabase start` e escrever testes de integração reais contra uma
  instância local — não feito agora por escopo.
- `SUPABASE_URL`/`SUPABASE_ANON_KEY` entram no app via
  `--dart-define-from-file=.env` (recurso nativo do Flutter, sem pacote
  adicional) — só essas duas chaves são lidas em `lib/`.
  `SUPABASE_SERVICE_ROLE_KEY` fica no `.env` local (fora do controle de
  versão) mas nunca é referenciada pelo app cliente.

## Alternativas descartadas
- **Manter Drift local + camada de sync própria**: resolveria o
  compartilhamento sem exigir conexão permanente, mas exige construir do
  zero resolução de conflito, fila offline e um backend próprio para
  orquestrar o sync — infraestrutura muito maior do que usar um BaaS
  pronto, para um app de uso privado de duas pessoas.
- **Firebase/Firestore**: alternativa de BaaS igualmente viável, mas
  Supabase foi a escolha explícita do usuário; Postgres relacional também
  encaixa melhor no modelo de dados já desenhado (foreign keys reais,
  agregações SQL) do que um banco de documentos.
- **Manter Drift como cache local + Supabase como fonte de verdade**:
  arquitetura offline-first "de verdade" (grava local, sincroniza em
  background), mas é significativamente mais complexa e não foi pedida —
  fica como evolução futura se o app precisar funcionar sem internet.
