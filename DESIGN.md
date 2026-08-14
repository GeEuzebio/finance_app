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
- **Navegação**: `NavigationBar` (bottom tabs) — padrão nativo pra 2-5
  seções de topo (`operate.md`), cresce conforme M6 ganha telas. O
  indicador de aba selecionada herda o âmbar do `ColorScheme.primary`
  automaticamente, sem estilização manual.
- **Linha de dia (projeção)**: data (âmbar só no chip "HOJE", texto normal
  nos demais dias — não é decoração, é o único destaque de "agora"),
  saldo em números tabulares à direita, "Livre: ..." como linha secundária
  mutada quando há reserva ativa (`projection_screen.dart`).
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

## O que falta (não inventado aqui)

- Projeção diária (#014), check-in diário (#015), gestão de cartões
  (#016) e reservas e objetivos (#017) — as 4 superfícies do M6 —
  existem. Nenhuma tela nova prevista fora do backlog (importação
  OFX/CSV, "saldo comprometido com fatura", gráficos).
- Gráfico de saldo ao longo do tempo: fora de escopo por decisão explícita
  (`docs/ROADMAP.md`, Backlog) — a tela de projeção é só a lista por
  enquanto.
- Nenhum ícone/asset autoral foi desenhado — os ícones são do pacote
  Material padrão (`Icons.*`), consistente com "produto pode usar fontes
  de sistema e ícones familiares" (`operate.md`, permissões de produto).
- Sem teste automatizado de contraste — os pares de cor foram escolhidos
  visualmente contra os dois fundos (screenshots dark/light no simulador),
  não auditados com uma ferramenta de WCAG.
