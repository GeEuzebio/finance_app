# ADR 0004 — Modelagem de recorrência: split simples

## Contexto
O produto precisa distinguir três edições de uma série recorrente: editar
uma única ocorrência, editar "esta e as futuras" e editar a série inteira
(`docs/CASHFLOW_ENGINE.md` §3). O caso "esta e as futuras" é o que tem mais
de uma forma razoável de modelar: manter histórico auditável completo de
cada edição (estilo event sourcing) ou um split simples da regra em duas.
Essa decisão muda o schema (`RecurrenceRules`) e a complexidade da engine de
expansão de ocorrências, por isso foi levada ao usuário como pergunta
bloqueante antes de escrever qualquer documento.

## Decisão
Split simples: ao editar "esta e as futuras" a partir de uma data D, a
`RecurrenceRule` vigente recebe `endDate = D − 1 dia` (ou
`occurrenceCount` ajustado, se a regra usava contagem) e uma nova
`RecurrenceRule` é criada com `startDate = D` e os novos parâmetros
(valor, dia, frequência). Nenhuma tabela de histórico/auditoria de edições é
criada.

## Consequências
- `expandirRecorrencia` (CASHFLOW_ENGINE.md §2, §3) processa cada
  `RecurrenceRule` isoladamente — nunca precisa saber que duas regras "eram"
  a mesma série antes de um split. Mantém a engine simples.
- Não há como reconstruir, a partir do banco, o histórico de todas as
  edições que uma série já sofreu (ex.: "esse aluguel já mudou de valor 3
  vezes ao longo do tempo") — só o estado final de cada trecho da série.
  Se essa necessidade aparecer, é uma migration futura para uma tabela de
  auditoria, não uma mudança na engine.
- Editar 1 ocorrência isolada continua sendo resolvido por uma `Transaction`
  concreta vinculada (`recurrenceRuleId` + data), sem qualquer relação com
  este ADR — não gera split de regra.

## Alternativas descartadas
- **Histórico auditável completo (event sourcing de regras)**: cada edição
  gera uma nova versão rastreável, com uma tabela extra de histórico e
  necessidade de "reduzir" a versão vigente em toda leitura. Rejeitado por
  ser complexidade adicional sem requisito de produto que a justifique agora
  (nenhum pilar do produto pede trilha de auditoria de edições) — YAGNI.
