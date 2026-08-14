# Cashflow Engine

> A engine de projeção diária é o núcleo do produto (pilar 1). Este documento
> é autossuficiente: qualquer pessoa deve conseguir implementar
> `projectCashflow` a partir daqui, sem perguntar nada a mais.

## 1. Assinatura

```dart
/// Função pura, determinística, sem I/O. Não lê relógio, não lê banco,
/// não depende de "hoje" para nada além do que o chamador passar em
/// [horizonStart]/[horizonEnd]. Mesma entrada -> sempre a mesma saída.
List<DailyBalance> projectCashflow({
  required List<AccountSnapshot> accounts,
  required List<Transaction> transactions,
  required List<RecurrenceRule> recurrenceRules,
  required List<CreditCard> creditCards,
  required List<Invoice> invoices,
  required List<InvoiceItem> invoiceItems,
  required List<Reserve> reserves,
  required DateOnly horizonStart,
  required DateOnly horizonEnd,
});

class AccountSnapshot {
  final String id;
  final int initialBalanceCents;   // saldo conciliado, não teórico
  final DateOnly initialBalanceDate;
  final bool archived;             // archived = fora da projeção (individual e consolidada)
}
```

### Invariantes
- Não faz nenhuma chamada de I/O (sem Drift, sem `DateTime.now()` interno).
  Todo dado necessário chega pelos parâmetros.
- Determinística: as mesmas listas de entrada + mesmo horizonte sempre
  produzem a mesma lista de saída, byte a byte.
- `horizonStart <= horizonEnd`; se `accounts` estiver vazia, retorna `[]`.
- Retorna `Either<ProjectionFailure, List<DailyBalance>>` no boundary do
  caso de uso (a função "pura" em si pode ser `List<DailyBalance>` direto e
  lançar um erro de programação — `assert` — para inputs impossíveis como
  `RecurrenceRule.endDate < startDate`, já que isso deveria ter sido
  bloqueado por `ValidationFailure` na escrita, não na leitura; a validação
  de escrita fica fora do escopo da engine).
- Saída contém uma linha de `DailyBalance` por dia do horizonte, por conta
  não arquivada (`accountId` preenchido) **e** uma linha consolidada por dia
  (`accountId == null`), mesmo em dias sem nenhum evento.
- Horizonte padrão (definido pelo chamador, não pela engine): 12 meses.

## 2. Pseudocódigo

```
função projectCashflow(...):
  contasAtivas = accounts.where(!archived)
  se contasAtivas.isEmpty: retorna []

  # 1. Expandir recorrências em ocorrências virtuais dentro do horizonte
  ocorrenciasVirtuais = []
  para cada regra em recurrenceRules:
    datas = expandirRecorrencia(regra, horizonStart, horizonEnd)  # ver §3
    para cada data em datas:
      ocorrenciasVirtuais.add(EventoVirtual(regra.accountId, regra.amountCents,
                                             data, regra.id))

  # 2. Remover ocorrências virtuais que já têm uma Transaction concreta
  #    vinculada (ajuste, adiamento ou cancelamento pontual daquela data)
  datasComOverride = transactions
      .where(t => t.recurrenceRuleId != null)
      .map(t => (t.recurrenceRuleId, dataDaOcorrenciaOriginal(t)))
      .toSet()
  ocorrenciasVirtuais = ocorrenciasVirtuais
      .where(ev => (ev.recurrenceRuleId, ev.data) not in datasComOverride)

  # 3. Resolver faturas de cartão em débitos na conta de pagamento
  debitosDeFatura = []
  para cada invoice em invoices:
    totalCents = soma(item.amountCents para item em invoiceItems
                       se item.invoiceId == invoice.id)
    jaTemPagamentoConcreto = transactions.any(t =>
        t.invoicePaymentForId == invoice.id)
    se totalCents != 0 e não jaTemPagamentoConcreto:
      debitosDeFatura.add(EventoVirtual(invoice.creditCard.paymentAccountId,
                                         totalCents, invoice.dueDate, null))

  # 4. Montar timeline final por conta: pontuais + recorrentes virtuais +
  #    débitos de fatura virtuais, todos convertidos pro mesmo formato de
  #    evento, EXCLUINDO status == cancelado
  eventosPorConta = agrupar_por(accountId,
      transactions.where(t => t.status != cancelado)
        + ocorrenciasVirtuais
        + debitosDeFatura)
  # nota: uma Transaction com status=adiado NÃO soma na data original — ela
  # representa a ocorrência que "saiu" dali; a nova ocorrência (status=previsto,
  # apontando de volta via originalTransactionId) é quem soma na nova data.
  eventosPorConta = eventosPorConta.map(lista =>
      lista.where(e => e.status != adiado))

  # 5. Indexar eventos por data (Map<DateOnly, List<Evento>>) por conta —
  #    O(1) por dia em vez de O(n) por dia, garante o orçamento de performance
  índice = eventosPorConta.map(lista => groupBy(lista, e => e.date))

  # 6. Acumular saldo diário por conta
  resultado = []
  para cada conta em contasAtivas:
    saldo = conta.initialBalanceCents
    para dia de min(horizonStart, conta.initialBalanceDate) até horizonEnd:
      eventosDoDia = índice[conta.id][dia] ?? []
      creditos = soma(e.amountCents para e in eventosDoDia se e.amountCents > 0)
      debitos  = soma(-e.amountCents para e in eventosDoDia se e.amountCents < 0)
      abertura = saldo
      saldo = saldo + creditos - debitos
      se dia >= horizonStart:
        resultado.add(DailyBalance(dia, conta.id, abertura, saldo,
                                    creditos, debitos, null))

  # 7. Consolidar (soma de todas as contas ativas por dia)
  para dia de horizonStart até horizonEnd:
    abertura = soma(db.openingBalanceCents para db em resultado
                     se db.date == dia)
    fechamento = soma(db.closingBalanceCents para db em resultado
                        se db.date == dia)
    reservasAtivas = soma(r.currentAmountCents para r em reserves)
    resultado.add(DailyBalance(dia, null, abertura, fechamento,
                                creditosConsolidados, debitosConsolidados,
                                fechamento - reservasAtivas))

  retorna resultado
```

### §3 — `expandirRecorrencia(regra, from, to)`
```
função expandirRecorrencia(regra, from, to):
  datas = []
  cursor = regra.startDate
  n = 0
  enquanto cursor <= to e cursor <= (regra.endDate ?? to)
             e (regra.occurrenceCount == null ou n < regra.occurrenceCount):
    se cursor >= from: datas.add(cursor)
    n += 1
    cursor = proximaData(regra, cursor, n)
  retorna datas

função proximaData(regra, dataAtual, n):
  base = regra.startDate
  switch regra.frequency:
    weekly:  retorna base + (n * 7 dias)
    monthly: retorna clampParaUltimoDiaDoMes(
                 ano: base.year + (base.month - 1 + n*regra.interval) ~/ 12,
                 mes: (base.month - 1 + n*regra.interval) % 12 + 1,
                 dia: base.day)
    yearly:  retorna clampParaUltimoDiaDoMes(base.year + n*regra.interval,
                                              base.month, base.day)
    custom:  retorna base + (n * regra.interval dias)
```
`clampParaUltimoDiaDoMes` gera a data pedida; se o dia não existir naquele
mês (ex.: dia 31 em fevereiro), usa o último dia real do mês (§ regra de dia
inválido, resolvida abaixo).

## 3. Regras de negócio resolvidas

### Recorrência
- Frequências suportadas: `weekly`, `monthly`, `yearly`, `custom` (intervalo
  em dias).
- **Dia inválido** (⚠️ SUPOSIÇÃO): clamp para o último dia do mês. Regra
  "todo dia 31": em fevereiro/2026 (28 dias, não bissexto) → ocorrência em
  28/02/2026; em fevereiro/2028 (29 dias, bissexto) → ocorrência em
  28... na verdade 29/02/2028. Justificativa: nunca "pular" silenciosamente
  uma ocorrência é mais previsível — o pilar do produto é previsibilidade, e
  uma ocorrência ausente sem aviso seria pior que uma data ajustada.
- Fim de série: `endDate` OU `occurrenceCount`, nunca os dois (validação de
  escrita, fora da engine); nenhum dos dois = infinita (limitada na prática
  pelo `horizonEnd` passado pelo chamador).
- Editar 1 ocorrência / editar "daqui em diante" / editar toda a série: são
  decisões de escrita (fora da engine — ver `docs/ARCHITECTURE.md` §4 e
  ADR 0004). A engine só enxerga o resultado: `RecurrenceRule`s (possivelmente
  já divididas em duas por um split) + `Transaction`s concretas que
  sobrescrevem ocorrências pontuais.

### Cartão de crédito
- Compra **até** o dia do fechamento (inclusive) cai na fatura do ciclo
  atual; compra **após** o fechamento cai na fatura seguinte. Ou seja,
  `purchaseDate.day <= closingDay` (ajustado para o mês/ciclo correto) →
  fatura atual. Ver caso de teste #7 (compra no mesmo dia do fechamento).
- Parcelamento em N vezes: `base = totalCents ~/ n`,
  `resto = totalCents - base*n`; as primeiras `resto` parcelas (em ordem,
  1ª, 2ª, ...) recebem `base + 1`, as demais recebem `base`. Cada parcela
  vira um `InvoiceItem` com `purchaseDate` avançando um mês por parcela
  (⚠️ SUPOSIÇÃO: só para determinar em qual fatura cada parcela cai — não é
  uma nova compra real) e vai para a fatura correspondente pela mesma regra
  de fechamento acima.
- Data de vencimento (`Invoice.dueDate`, resolvida por `FindOrCreateInvoice`
  ao criar a fatura): ⚠️ SUPOSIÇÃO — cai no mesmo mês do fechamento se
  `dueDay >= closingDay`; se `dueDay < closingDay`, cai no mês seguinte
  (padrão comum de fatura brasileira — fecha dia 25, vence dia 5 do mês
  seguinte). Mesmo clamp de dia inválido do resto do sistema
  (`clampedMonthDate`, `core/utils/date_only.dart`).
- Vencimento em fim de semana/feriado: ⚠️ SUPOSIÇÃO — **mantém a data**, sem
  ajuste automático. Um calendário de feriados nacional/estadual/municipal é
  escopo desnecessário para v1; o usuário ajusta manualmente via check-in se
  o banco antecipar/postergar o débito real.
- Pagamento parcial / rotativo: ⚠️ SUPOSIÇÃO — fora do escopo v1. A fatura é
  binária: ao ser paga, gera uma única `Transaction` de débito de
  `totalCents` (já negativo) na `paymentAccountId`, na `dueDate`.
- Estorno: um `InvoiceItem` com `amountCents` positivo, na mesma
  `purchaseGroupId` da compra original, na fatura vigente no momento do
  estorno (fatura atual se antes do fechamento; fatura já fechada só se o
  estorno também puder ser lançado em fatura fechada — ⚠️ SUPOSIÇÃO: um
  estorno pós-fechamento entra na fatura **aberta atual**, nunca reabre uma
  fatura já fechada). `Invoice.totalCents = Σ InvoiceItem.amountCents`,
  então o estorno reduz o total naturalmente — se zerar, nenhuma
  `Transaction` de pagamento é gerada (ver caso de teste #15).
- Moeda estrangeira: fora de escopo (produto é mono-moeda BRL, decisão da
  sessão).

### Projeção
- `saldo(d) = saldo(d-1) + Σcréditos(d) − Σdébitos(d)`.
- Ponto de partida: `AccountSnapshot.initialBalanceCents` no
  `initialBalanceDate` — sempre o saldo **conciliado**, nunca teórico.
- **REGRA CRÍTICA — previsão vencida e não conciliada**: permanece na data
  original. A engine não tem noção de "hoje" além do `horizonStart` recebido
  como parâmetro, e um item `previsto` soma normalmente na sua própria
  `date`, esteja ela no passado ou no futuro em relação a quando a função é
  chamada. Não existe "arrastar para hoje". A "fila de pendências" mostrada
  no Check-in Diário é uma **query separada**, fora da engine:
  `transactions.where(status == previsto && date < hoje)` — ver caso de
  teste #12, que prova que rodar a função em datas diferentes não muda o
  resultado para o mesmo dia (determinismo).
- Múltiplas contas: a engine sempre devolve linhas por conta **e** uma linha
  consolidada por dia (soma das contas ativas).
- Transferência entre contas próprias: dois eventos (`transferGroupId`
  igual) — um débito numa conta, um crédito noutra. Cada conta é afetada
  individualmente; a soma consolidada não muda, porque débito e crédito se
  cancelam ao somar todas as contas (ver caso de teste #10).

### Reservas
- `freeBalance(d) = closingBalanceConsolidado(d) − Σ Reserve.currentAmountCents`.
  Só calculado na linha consolidada (reservas não são por conta).
- Aporte em reserva não gera evento na engine (não é `Transaction`); o valor
  de `Reserve.currentAmountCents` é lido diretamente no passo 7. Isso
  decorre direto do enunciado do produto ("recortadas do saldo disponível
  sem serem despesa"), não é suposição.
- ⚠️ SUPOSIÇÃO: toda `Reserve` cadastrada é sempre "ativa" (conta no saldo
  livre) — não há arquivamento de reserva na v1; para liberar o valor, o
  usuário reduz `currentAmountCents` ou exclui a reserva.

### Estados do lançamento
- `previsto`: soma normalmente na sua `date`.
- `confirmado`: mesmo efeito de `previsto` na soma (valor/data batem) —
  a diferença é só de UI/histórico (marca que foi conciliado).
- `ajustado`: soma o **novo** `amountCents`/`date` (já são os valores
  armazenados na própria `Transaction` — a engine não faz nada especial).
- `adiado`: a ocorrência original **não soma** na data original (passo 4 do
  pseudocódigo); a nova ocorrência gerada (status `previsto`, apontando de
  volta via `originalTransactionId`) soma normalmente na nova data.
- `cancelado`: excluída da soma inteiramente (passo 4), mantida na tabela
  para histórico.

## 4. Meta de performance

Projeção de 12 meses (365 dias) com 500 lançamentos (pontuais + ocorrências
de recorrência já expandidas) deve rodar em **< 50ms** em um dispositivo
médio. Estratégia: indexar eventos por data em `O(n)` (passo 5) antes do
loop de acumulação, para que o loop diário seja `O(dias)` com lookup `O(1)`
por dia, em vez de `O(dias × n)`. `n = 500` e `dias = 365` tornam até a
versão ingênua (`O(dias × n) = 182.500` comparações) rápida em Dart puro sem
I/O — o índice é para manter a margem confortável conforme o volume de
lançamentos cresce em versões futuras (multi-ano, mais contas).

## 5. Casos de teste (mínimo 12)

Todos os valores em centavos. `A`, `B` = contas fictícias.

| # | Cenário | Entrada relevante | Saída esperada |
|---|---|---|---|
| 1 | Crédito e débito no mesmo dia | `A.initial=100000` em 01/08/2026; pontuais em 01/08: `+50000`, `-20000` | `closing(01/08/2026, A) = 130000` |
| 2 | Recorrência mensal simples | Regra `-300000`, `monthly`, `startDate=05/01/2026`, sem fim; `A.initial=1000000` em 01/01/2026 | `closing(05/01)=700000`; `closing(05/02)=400000`; `closing(05/03)=100000` |
| 3 | Dia inválido — fevereiro não bissexto | Regra `-50000`, `monthly`, `startDate=31/01/2026`; `A.initial=500000` em 01/01/2026 | Ocorrências em 31/01, **28/02/2026** (clamp), 31/03; `closing(28/02)=400000` |
| 4 | Dia inválido — fevereiro bissexto | Mesma regra, `startDate=31/01/2028` | Ocorrência clampada em **29/02/2028** (não 28) |
| 5 | Virada de ano | Regra `-80000`, `monthly`, `startDate=15/12/2026`, sem fim; `A.initial=200000` em 01/12/2026 | `closing(15/12/2026)=120000`; `closing(15/01/2027)=40000` |
| 6 | Compra de cartão antes do fechamento | Cartão `closingDay=10, dueDay=20`; compra `-15000` em 08/03/2026 | Item entra na fatura de referência 2026-03; pagamento `-15000` debitado em `A` em 20/03/2026 |
| 7 | Compra no mesmo dia do fechamento | Mesmo cartão; compra `-20000` em **10/03/2026** (== closingDay) | Item entra na fatura **de março** (não abril) — fechamento é inclusivo |
| 8 | Parcelamento com resíduo de centavo | Compra `10000` (R$100,00) em 3x, cartão `closingDay=10`, compra em 01/05/2026 | Parcelas: `-3334, -3333, -3333` (soma = `-10000`); 1ª no ciclo de maio, 2ª junho, 3ª julho |
| 9 | Saldo negativo | `A.initial=10000` em 01/04/2026; débito `-50000` em 05/04/2026 | `closing(05/04)=-40000` (engine não bloqueia nem lança erro) |
| 10 | Transferência entre contas próprias | `A.initial=100000`, `B.initial=50000` em 01/06/2026; transferência `30000` em 10/06/2026 (`A:-30000`, `B:+30000`, mesmo `transferGroupId`) | `closing(10/06,A)=70000`; `closing(10/06,B)=80000`; consolidado(10/06) = `150000` (igual ao de 01/06 — inalterado) |
| 11 | Reserva reduz saldo livre, não o total | Consolidado `closing(01/07/2026)=200000`; `Reserve.currentAmountCents=50000` | `freeBalance(01/07)=150000`; `closingBalanceCents` consolidado continua `200000` |
| 12 | Previsão vencida não conciliada (determinismo) | `Transaction(status=previsto, date=05/08/2026, amount=-40000)`; função chamada com `horizonStart=01/08` e, em outra chamada, com `horizonStart=09/08`, mesmos dados | `closing(05/08/2026)` idêntico nas duas chamadas — o item nunca "arrasta" para 09/08 |
| 13 | Cancelamento | `Transaction(status=cancelado, date=12/08/2026, amount=-25000)` | `closing(12/08)` = `opening(12/08)` (débito ignorado na soma) |
| 14 | Adiamento | Original `(status=adiado, date=03/08/2026, amount=-10000)`; nova ocorrência `(status=previsto, date=10/08/2026, amount=-10000, originalTransactionId=original.id)` | `closing(03/08)` não sofre o débito; `closing(10/08)` sofre `-10000` |
| 15 | Estorno zera a fatura | Cartão `closingDay=10`; compra `-8000` em 03/09/2026; estorno `+8000` em 05/09/2026 (antes do fechamento, mesma `purchaseGroupId`) | `Invoice(2026-09).totalCents = 0`; nenhuma `Transaction` de pagamento é gerada |

Cada linha acima corresponde a um `test()` em
`test/features/cashflow_engine/project_cashflow_test.dart`.
