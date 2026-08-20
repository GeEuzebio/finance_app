# ADR 0007 — Sugestões de IA sobre gastos: opt-in, dado agregado, sob demanda

## Contexto
M7, #031: o usuário pediu avaliação de integrar um modelo de IA que
analise entradas/gastos e sugira redução de despesa e melhora de
economia, com pesquisa de estudos/artigos de apoio. A pesquisa (busca
web) encontrou evidência real de efetividade — identificação de gasto
excessivo em 88% dos usuários de apps com IA financeira, melhora média
de ~18% na taxa de poupança, redução de 15,3% em dívida entre usuários
com meta de quitação — e duas restrições técnicas/legais que moldaram a
decisão:

- **Chave de API nunca pode morar no app Flutter**: é um binário
  decompilável, então qualquer segredo embutido é extraível. Exige uma
  peça server-side.
- **LGPD**: renda/gastos/dívida são dado pessoal protegido. Compartilhar
  com IA de terceiro exige finalidade clara, base legal (aqui:
  consentimento explícito) e possibilidade de revogação a qualquer
  momento — não pode ser automático nem ligado por padrão.

Isso é adjacente à ADR 0006, que rejeitou `banco-mcp`/UPX por mandarem
dado bancário **automaticamente**, sem escolha do usuário, pra um host
de IA de terceiro. A diferença de raiz aqui: é o próprio app, sob
**comando explícito do usuário**, mandando um resumo **já agregado**
(não dado bruto, sem descrição de lançamento nem nome de
estabelecimento) pra um provedor de IA escolhido, com opt-in e
finalidade única e disclosada. Mas o princípio de fundo — dado
financeiro saindo do Supabase — é o mesmo, por isso vira uma ADR nova em
vez de uma reversão silenciosa da 0006.

## Decisão
Implementar sugestões de IA com três restrições de design, todas
tratadas como não-negociáveis:

1. **Opt-in explícito, desligado por padrão** — switch em
   Configurações ("Sugestões por IA"). Sem ele ligado, nenhum dado sai
   do app.
2. **Só dado agregado por categoria** — o payload é `categoryCents`
   (rótulo, não descrição de lançamento), a saída do guia 50/30/20
   (`budget503020`), `savedCents`/`savingsPercent` e dívida de fatura
   atrasada. Nenhuma descrição de lançamento, nome de estabelecimento ou
   identificador de conta é enviado.
3. **Geração sob demanda, nunca automática** — botão "Gerar sugestões"
   em `month_screen.dart`; sem cron, sem trigger de banco, sem geração
   ao abrir a tela.

A peça server-side é uma **Supabase Edge Function**
(`supabase/functions/financial-insights`, Deno) — reaproveita a
infraestrutura já usada pelo app em vez de introduzir um novo provedor
de hosting. Ela chama a API da Anthropic (`claude-haiku-4-5`) com a
chave `ANTHROPIC_API_KEY` como secret do Supabase, nunca no client. O
prompt instrui explicitamente o modelo a **não recalcular nenhum
valor** — só interpretar os números já exatos recebidos — mesmo
princípio de "confiança em dinheiro" que já rege o resto do app
(`PRODUCT.md`).

## Consequências
- Nova peça de infraestrutura (Edge Function) além do Supabase/Postgres
  já usado — mas ainda dentro do mesmo provedor, sem novo serviço de
  hosting.
- Dependência de um provedor de IA de terceiro (Anthropic) só quando o
  usuário liga o toggle e aperta o botão — nunca por padrão, nunca em
  segundo plano.
- Custo variável por chamada à API da Anthropic (cobrança própria do
  usuário, separada de qualquer assinatura do Claude Code) — mitigado
  por ser sob demanda e por usar um modelo econômico (Haiku).
- Estado das sugestões vive só em memória (sem tabela de cache) —
  ponytail: MVP; se a re-geração a cada sessão incomodar na prática,
  persistir fica como upgrade futuro.
- Segue coerente com a ADR 0006: nenhum dado bancário bruto sai do
  Supabase automaticamente; o único dado que sai é agregado, sob
  comando explícito, com finalidade disclosada na própria tela.

## Alternativas descartadas
- **IA rodando no app cliente (on-device ou com chave embutida)**:
  descartado — chave de API extraível de um binário decompilável, sem
  alternativa segura de embedding.
- **Geração automática (ex.: toda vez que o mês fecha)**: descartado —
  fere o requisito de consentimento explícito da LGPD e o princípio de
  "uso a dois sem fricção" não inclui decisão silenciosa de compartilhar
  dado com terceiro.
- **Enviar lançamentos individuais/descrições**: descartado — não
  necessário pro objetivo (sugestão de categoria/hábito, não auditoria
  de lançamento) e amplia desnecessariamente a superfície de dado
  exposta a terceiro.
