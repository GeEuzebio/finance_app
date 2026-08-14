# ADR 0001 — Gerenciamento de estado com Riverpod

## Contexto
O app precisa de um único mecanismo de estado, usado de ponta a ponta:
providers para dados reativos vindos do Drift (streams de contas, saldos
projetados recalculados quando um lançamento muda), estado de formulários
(cadastro de conta, lançamento, cartão) e o resultado da engine de projeção
mantido em memória e invalidado quando a base muda. Precisa também compor bem
com `get_it`/`injectable` para DI (ADR 0003), já que os repositórios
concretos são resolvidos pelo container, não construídos direto pelos
providers.

## Decisão
Riverpod (`flutter_riverpod` + `riverpod_generator`) como único mecanismo de
estado em todo o projeto — nenhuma tela mistura Riverpod com `setState`,
`Provider` (package `provider`) ou Bloc.

## Consequências
- Providers `@riverpod` para: streams de leitura (via DAOs Drift expostos
  como `Stream` através dos repositórios), o resultado de
  `projectCashflow` (como um `Provider` derivado que recalcula quando as
  streams de entrada mudam) e controllers de formulário (`AsyncNotifier`).
- `ref.watch` de providers de repositório resolve a instância via `get_it`
  dentro do provider (`GetIt.I<AccountRepository>()`), mantendo a fronteira
  domain/data intacta mesmo com Riverpod no meio.
- Testabilidade: providers puros são testáveis com `ProviderContainer`
  isolado, sem precisar montar widget tree — importante para testar o
  provider que expõe `projectCashflow` sem UI.
- Curva de aprendizado do `riverpod_generator` (código gerado) é aceita em
  troca de segurança de tipos e menos boilerplate manual de `Provider`.

## Alternativas descartadas
- **Bloc/Cubit**: mais boilerplate para o mesmo resultado; equipe pequena não
  se beneficia da separação event/state extra que o Bloc impõe.
- **`provider` (package clássico)**: sem suporte de primeira classe a estado
  assíncrono combinável (`AsyncNotifier`) nem a invalidação automática de
  dependências que a engine de projeção precisa (recalcular quando qualquer
  lançamento upstream muda).
- **`setState` puro / `ValueNotifier` manual**: não escala para o grafo de
  dependências entre contas → lançamentos → projeção → saldo livre; forçaria
  reimplementar manualmente o que Riverpod já resolve.
