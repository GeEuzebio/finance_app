# ADR 0003 — Injeção de dependência com get_it + injectable

## Contexto
A regra de arquitetura (`docs/ARCHITECTURE.md` §2) exige que `presentation`
nunca instancie `data` diretamente — sempre resolva contratos de `domain`
por trás dos quais vivem implementações concretas de `data` (repositórios
Drift). Isso precisa de um mecanismo de composição na raiz do app
(`main.dart`) que registre todas as implementações uma única vez, e de um
jeito que Riverpod (ADR 0001) consiga consumir dentro dos providers.

## Decisão
`get_it` como service locator + `injectable` para gerar o registro
(`@LazySingleton`, `@Injectable`) via `build_runner`, evitando registrar
cada dependência manualmente em `injection.dart`.

## Consequências
- `configureDependencies()` chamado uma vez em `main.dart` antes de
  `runApp`, registrando `AppDatabase`, todos os DAOs, todos os
  `XRepositoryImpl` (anotados `@LazySingleton(as: XRepository)`) e casos de
  uso.
- Providers Riverpod resolvem dependências via `GetIt.I<XRepository>()`
  dentro do corpo do provider — Riverpod cuida do ciclo de vida de estado
  reativo, `get_it` cuida só de composição/instanciação.
- Testes de unidade da engine e de casos de uso não passam pelo `get_it` —
  instanciam a classe direto com fakes/mocks, já que são funções/classes
  puras de `domain`. `get_it` só entra na borda de composição do app real.
- `injectable_generator` exige anotação em cada implementação
  (`@LazySingleton(as: ...)`), o que documenta explicitamente, no próprio
  código, qual implementação concreta atende qual contrato — reforça a regra
  de importação em vez de escondê-la.

## Alternativas descartadas
- **Riverpod puro como DI** (sem `get_it`, todo repositório vira um
  `Provider`): funcionaria, mas misturaria "composição de dependências" com
  "estado reativo de UI" no mesmo mecanismo, dificultando trocar/mockar
  implementações em teste de casos de uso que não quer subir um
  `ProviderContainer`. Manter os dois papéis separados (get_it = composição,
  Riverpod = estado) deixa cada ferramenta fazendo uma coisa só.
- **Registro manual sem `injectable`**: viável para poucas classes, mas o
  roadmap já prevê 8 entidades × repositório × DAO × casos de uso — registro
  manual cresceria como boilerplate repetitivo sem trazer benefício sobre a
  geração de código.
