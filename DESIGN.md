# Design — "Horizonte"

<!-- impeccable:design-schema 1 -->

Registro do mundo visual construído (não uma intenção prévia — reflete o
código em `lib/core/theme/app_theme.dart` e `lib/features/accounts/presentation/`).

## Direção

**Tese**: o diferencial do produto é prever o futuro, não catalogar o
passado — o visual reforça isso com uma única cor de destaque (âmbar,
"olhar pra frente") sobre uma base escura calma, em vez de competir por
atenção com várias cores como apps de categorização de gasto fazem.

**Modo**: Operate (o app é uma ferramenta de tarefa, não uma página de
venda) — por isso a base é restrita (neutros + 1 accent), os componentes
seguem convenções nativas reconhecíveis, e não foi construído um "mundo
visual" exótico. Ver `docs/adr/` para o precedente de não reabrir decisões
de arquitetura sem necessidade; o mesmo princípio de conservadorismo se
aplica aqui a navegação/controles.

**Plataforma**: Flutter, Android + iOS, uma identidade visual única nos
dois SOs — não Material-no-Android/Cupertino-no-iOS (confirmado com o
usuário no init).

**Referências reais pesquisadas**: Monzo (coral), Nubank (roxo), Wise
(verde), Cash App (verde), Robinhood (chartreuse) — cada um com UMA cor de
marca sobre base neutra, nunca paleta cheia; Copilot Money como referência
de execução (dark mode de primeira classe, tipografia limpa, nada de
decoração) — ver fontes na conversa que originou este documento.

## Tokens

Definidos em `lib/core/theme/app_theme.dart`, classe `AppColors`. Dark e
light não são opostos arbitrários: são pontos na mesma rampa de matiz
(ink azulado), o que mantém os dois modos parecendo o mesmo produto.

| Papel | Dark | Light |
|---|---|---|
| Fundo | `#0E1116` | `#F4F5F8` |
| Superfície (card) | `#171B24` | `#FFFFFF` |
| Texto | `#EDEFF3` | `#14161C` |
| Texto secundário | `#9297A6` | `#5B6072` |
| Borda | `#262B36` | `#E3E5EB` |
| **Accent (único)** | `#E8A33D` (âmbar) — igual nos dois modos | |
| Crédito (dinheiro) | `#5FB88A` | `#2F8F63` |
| Débito (dinheiro) | `#D97066` | `#B84D3F` |

Regra de uso do âmbar: só em ação primária (FAB, botão principal) e no que
representa "o que vem pela frente" nas telas de projeção futuras — nunca
decoração solta. Vermelho/verde de dinheiro são sempre os semânticos
acima, nunca o âmbar (evita ambiguidade entre "destaque de marca" e
"dinheiro saindo/entrando").

## Tipografia

Inter (via `google_fonts`) em todo o app — uma família só, como
`operate.md` recomenda para produto (não precisa de par display/body).
Números monetários sempre com `FontFeature.tabularFigures()`
(`AppTheme.money()`), pra colunas de valores alinharem e não "dançarem"
entre estados — decisão ligada ao princípio de produto "confiança em
dinheiro" (`PRODUCT.md`).

## Componentes

- **Card de conta**: cantos raio 16, borda 1px (não sombra pesada), ícone
  circular por tipo de conta (`Icons.account_balance_outlined` etc.),
  nome + chip de dono (pílula com texto mutado) à esquerda, valor em
  números tabulares à direita (cor normal ou vermelho de débito se
  negativo).
- **Chip de dono**: pílula pequena, fundo neutro a 6% de opacidade sobre o
  texto, nunca colorida — o dono é metadado, não precisa competir
  visualmente com o valor.
- **FAB**: âmbar sólido, ícone `+` — convenção padrão de "adicionar",
  sem reinvenção.
- **Estado vazio**: ícone mutado + título + uma frase que ensina o próximo
  passo (não só "nada aqui") — `_EmptyState` em `accounts_screen.dart`.
- **Estado de erro**: ícone de alerta na cor de débito + mensagem —
  `_ErrorState` no mesmo arquivo.
- **Diálogo de criação**: mesma linguagem (cantos arredondados, superfície
  do card), `FilledButton` âmbar como ação primária.
- **Navegação**: bottom tabs pra 2-5 seções de topo (`operate.md`), cresce
  conforme M6/M7 ganham telas. De M0 a M7 foi a `NavigationBar` padrão do
  Material (indicador âmbar automático via `ColorScheme.primary`); trocada
  por `AnimatedBottomNavigationBar` (ver bullet "Navegação animada"
  abaixo), com o âmbar aplicado manualmente por não herdar mais do tema.
- **Linha de dia (projeção)**: formato planilha (M7, #020, reformulado no
  #026) — 3 colunas fixas (Dia / Diferença / Saldo) com cabeçalho em
  `labelSmall` mudo. Dia é compacto (número grande + dia da semana
  abreviado embaixo, chip "HOJE" só no dia de hoje — âmbar continua o
  único destaque de "agora"). Diferença é
  `projectedCreditsCents - projectedDebitsCents` do próprio dia, colorida
  (verde de crédito se positiva, vermelho de débito se negativa, "—" mudo
  quando não há movimento — nunca "R$ 0,00"). Saldo usa um gradiente
  contínuo entre vermelho e verde de débito/crédito (`Color.lerp`,
  normalizado pelo maior `|saldo|` do mês em exibição) — pedido do
  usuário inspirado na planilha do Breno, sinaliza de relance se o mês
  tende a ficar "no vermelho" sem precisar ler cada valor. A linha inteira
  é um `InkWell` com `chevron_right` mudo à direita — toca em qualquer
  lugar do card pra abrir `DayDetailScreen`, mesmo idioma de navegação do
  card de cartão (`projection_screen.dart`).
- **Seletor de mês/ano**: par de `IconButton` (chevron_left/right)
  ladeando o mês por extenso abreviado + ano de 2 dígitos ("Ago./26"),
  centralizado logo abaixo do `AppBar` — troca os dois parâmetros do
  provider de projeção, sem paginação nem calendário completo
  (`projection_screen.dart`).
- **Detalhamento do dia**: tela própria (`DayDetailScreen`) aberta ao
  tocar num dia da Projeção — banner de "Diferença do dia" no topo (mesma
  pílula colorida do banner de fatura comprometida) seguido da lista de
  itens, cada um um card com descrição + conta à esquerda, valor colorido
  à direita — sem os botões de ação do card de check-in, porque aqui é
  consulta, não uma fila de decisão (`day_detail_screen.dart`).
- **Botão de adicionar movimento**: `FloatingActionButton` (ícone `+`,
  âmbar do tema) na Projeção — abre o mesmo diálogo de lançamento avulso
  do #018, com um campo de data editável (`showDatePicker`), pra lançar
  em qualquer dia sem precisar já estar olhando pra ele
  (`projection_screen.dart`).
- **Destaque de risco**: dia com saldo previsto negativo ganha tingimento
  sutil (vermelho de débito a 8% de opacidade no fundo do card) + ícone de
  alerta — é o sinal de "análise de risco" que veio da conversa sobre
  ficar "refém do cartão" (ver `docs/ROADMAP.md`, seção Backlog). Não é
  cor de marca (âmbar) fazendo esse papel — risco usa o semântico de
  débito, âmbar continua reservado pra ação/destaque positivo.

- **Card de check-in**: mesma superfície/raio dos demais cards — descrição
  + nome da conta à esquerda, valor tabular à direita (vermelho de débito
  se negativo), e uma linha de 4 ações alinhadas à direita: cancelar (✕,
  cor de débito), adiar (ícone de calendário), ajustar valor (lápis, abre
  diálogo com campo numérico) e confirmar (`FilledButton` âmbar — é a ação
  primária do fluxo, então é a única com peso visual de botão cheio; as
  outras três são `IconButton`s discretos, porque confirmar é o caminho
  feliz e as demais são exceção) (`check_in_screen.dart`).
- **Diálogo de adiar**: usa `showDatePicker` nativo em vez de um diálogo
  autoral — não há necessidade de reinventar um seletor de data pra essa
  ação pontual.
- **Card de cartão (lista)**: mesmo layout do card de conta (ícone
  circular, nome + metadado à esquerda, valor à direita) — aqui o
  metadado é "Fecha dia X · Vence dia Y" em vez do chip de dono, e o
  valor é o limite (quando definido), não um saldo. `chevron_right`
  mudo à direita sinaliza que o card navega, sem precisar de um botão
  explícito (`cards_screen.dart`).
- **Card de resumo de fatura**: cabeçalho com mês de referência + chip de
  status (aberta/fechada/paga, mesma pílula neutra do chip de dono —
  status é metadado, não deve competir com o valor), datas de
  fechamento/vencimento em texto mutado, total em números tabulares
  grandes (vermelho de débito se negativo), e `FilledButton` "Pagar
  fatura" full-width — some quando a fatura já está paga, porque uma
  ação indisponível não deve aparecer desabilitada e sim não aparecer
  (`card_detail_screen.dart`).
- **Item de fatura**: descrição + "Parcela X/Y" (só quando há mais de 1
  parcela — parcela única não precisa desse rótulo) à esquerda, valor
  tabular à direita, ícone de estornar (`Icons.undo`) discreto — estorno
  é ação secundária de correção, não de fluxo principal, por isso não
  ganha peso de botão cheio como "Pagar fatura" ganha.
- **Card de reserva**: nome à esquerda, valor à direita — `atual / meta`
  em números tabulares quando há meta definida, só `atual` quando não há
  (uma reserva sem meta não devia mostrar uma fração vazia). Barra de
  progresso âmbar fina (6px, cantos arredondados) só aparece com meta —
  é a única tela do app com barra de progresso, reservada pra esse caso
  porque "meta com prazo visual" é um conceito que não existe em conta,
  fatura ou check-in. Linha de 3 `IconButton`s (excluir em vermelho de
  débito, resgatar, aportar) — sem botão cheio aqui, porque nenhuma das
  três é o caminho feliz único como "Confirmar" é no check-in
  (`reserves_screen.dart`).
- **Estados vazio/erro compartilhados**: `EmptyStateView`/`ErrorStateView`
  (`lib/core/widgets/state_views.dart`) — mesmo padrão (ícone mudo +
  título + frase; ícone de alerta em cor de débito + mensagem) que antes
  vivia duplicado em cada tela, agora um componente parametrizado
  (ícone/título/mensagem) reusado pelas 6 telas de lista.
- **Lançamentos**: 3 seções (`Contas fixas`, `Contas variáveis`,
  `Avulsos`) — só as que têm item aparecem, sem seção vazia decorativa.
  Cards de recorrência mostram "Conta · Frequência" como metadado; cards
  avulsos mostram "Conta · Data". Diálogo de criação usa
  `SegmentedButton` de 3 opções (Avulso/Fixa/Variável) que revela os
  campos de recorrência (frequência, intervalo, fim opcional) só quando
  não é avulso — mesmo princípio de "esconder o que não se aplica" do
  resto do app. Dropdown "Entrada/Saída" decide o sinal do valor digitado
  (`lancamentos_screen.dart`).
- **Configurações**: seções em `ListView` simples, sem card por seção —
  primeira tela do app que é uma lista de controles, não uma lista de
  itens de dados, então não precisa da moldura de `Card` que dá peso
  visual a "isto é um registro". `SegmentedButton` pra Aparência (escolha
  discreta, aplica na hora); `TextField` com `suffixIcon` de check pra
  Projeção/Economia (edição explícita, sem auto-save — mesmo padrão de
  "ação deliberada" do resto do app); `SwitchListTile` pra Notificações
  (M7, #022) — liga/desliga de verdade (pede permissão, agenda/cancela a
  notificação), com uma segunda linha "Horário" que só aparece quando o
  lembrete está ligado (esconder o que não se aplica, mesmo princípio do
  diálogo de Lançamentos) e abre o `showTimePicker` nativo; `ListTile`
  com `chevron_right` pra navegar a Contas/Cartões/Reservas, que saíram
  da bottom nav e agora só se chega por aqui (`settings_screen.dart`).
- **Mês**: 3 `Card`s empilhados — Performance (5 linhas: Entradas,
  Saídas, Custo diário, Economizado, Gastos com cartão — entradas e
  economizado em verde de crédito, o resto em vermelho de débito, mesmo
  quando "gastos com cartão" não é literalmente uma saída de conta, é
  semanticamente um débito do mês); Economia com chip "Ideal"/"Abaixo do
  ideal" (verde/vermelho, fundo a 15% de opacidade — mesma pílula neutra
  dos outros chips do app, só que colorida pela primeira vez, porque essa
  é a única tela cujo trabalho é julgar um resultado, não só reportar um
  valor) e o valor economizado em destaque (`headlineSmall`); Custo de
  vida com as 3 parcelas + `Divider` + Total em negrito — o total nunca é
  a soma literal das 3 linhas (custo diário é uma taxa, não uma parcela),
  então o divisor deixa claro que o Total é outra conta, não um subtotal
  (`month_screen.dart`).
- **Importar extrato**: tela de um passo só — dropdown de conta, botão de
  selecionar arquivo (`OutlinedButton`, âmbar — ação secundária em
  relação ao fluxo normal do app, mas primária nesta tela isolada, mesmo
  raciocínio do FAB em outras telas), preview das 5 primeiras linhas
  parseadas dentro de um `Card` antes de confirmar (nunca importa sem o
  usuário ver o que vai entrar), e um `FilledButton` "Importar" que só
  aparece depois que há algo pra importar — mesmo princípio de "esconder
  o que não se aplica" das outras telas (`import_screen.dart`).
- **Banner de fatura comprometida**: faixa colorida (débito a 8% de
  opacidade, mesmo tom do tingimento de risco) no topo da Projeção — só
  aparece quando há valor comprometido, nunca "R$ 0,00" — mesmo raciocínio
  de "esconder o que não se aplica". Fica **fora** da grade de dias
  porque não é um valor por dia, é um retrato de agora (`projection_screen.dart`).
- **Navegação animada, sem rótulo**: `AnimatedBottomNavigationBar.builder`
  (pacote `animated_bottom_navigation_bar`, pedido explícito do usuário)
  substituiu a `NavigationBar` padrão do Material — 5 abas só com ícone
  (âmbar quando ativo, mutado quando não), sem notch (`GapLocation.none`,
  o app não tem FAB flutuante sobre a bottom nav) e bolha de seleção com
  a animação nativa do pacote. Rótulo não existe mais como propriedade do
  widget — recriado via `Semantics(label: ...)` em volta de cada ícone
  pra não perder leitor de tela (`main.dart`).
- **Importar fatura**: mesma tela de importação de extrato ganhou um
  `SegmentedButton` Extrato/Fatura no topo — Extrato mantém o fluxo
  original (dropdown de conta); Fatura troca pra dropdown de cartão e
  gera `InvoiceItem` em vez de `Transaction`, mesmo preview de 5 linhas e
  mesmo `FilledButton` condicional das outras telas
  (`import_screen.dart`).

## O que falta (não inventado aqui)

- Projeção diária (#014), check-in diário (#015), gestão de cartões
  (#016) e reservas e objetivos (#017) — as 4 superfícies do M6 —
  existem, mais a tela de Lançamentos (fora do M6, adicionada depois pra
  desbloquear o uso real do app — ver `docs/ROADMAP.md`). Nenhuma tela
  nova prevista fora do backlog (importação OFX/CSV, "saldo comprometido
  com fatura", gráficos, Configurações, Mês, projeção em planilha).
- Gráfico de saldo ao longo do tempo: fora de escopo por decisão explícita
  (`docs/ROADMAP.md`, Backlog) — a tela de projeção é só a lista por
  enquanto.
- Nenhum ícone/asset autoral foi desenhado — os ícones são do pacote
  Material padrão (`Icons.*`), consistente com "produto pode usar fontes
  de sistema e ícones familiares" (`operate.md`, permissões de produto).
- Sem teste automatizado de contraste — os pares de cor foram escolhidos
  visualmente contra os dois fundos (screenshots dark/light no simulador),
  não auditados com uma ferramenta de WCAG.
