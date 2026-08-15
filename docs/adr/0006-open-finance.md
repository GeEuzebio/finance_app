# ADR 0006 — Open Finance adiado, caminho é importação OFX/CSV

## Contexto
Durante o M7 o usuário pediu avaliação de duas vias pra automatizar a
entrada de dados de banco/cartão em vez de lançar tudo à mão: (1) acesso
direto ao Open Finance Brasil, e (2) o servidor
`banco-mcp` (github.com/douglac/banco-mcp), levantado como possível
integração. Pesquisa feita na sessão (resultados de busca web, não
documentação lida em profundidade — ⚠️ SUPOSIÇÃO onde marcado):

- **Acesso direto ao Open Finance Brasil** exige ser instituição
  autorizada a funcionar pelo Banco Central (Resolução Conjunta BCB/CVM
  1/2020, art. 6º), com credenciamento como TPP (Third Party Provider),
  OAuth 2.0 + FAPI (Financial API Security Profile) + mTLS. Não é algo que
  um desenvolvedor individual ou um app doméstico consegue fazer sozinho.
- **Agregadores regulados** (Pluggy, Belvo) resolvem isso: eles já são a
  instituição autorizada/credenciada e expõem uma API própria por cima do
  Open Finance, sem o consumidor final precisar de licença. Mas exigem
  CNPJ, contrato comercial e mensalidade — modelo pensado pra empresas
  que vão servir muitos usuários finais, não pra um app privado de duas
  pessoas.
- **`banco-mcp`** é um **servidor MCP pra Claude/Cursor** (ferramenta de
  assistente de IA), não uma biblioteca ou API consumível por um app
  Flutter. Também usa Open Finance por baixo (provavelmente via algum
  agregador — não confirmado), e por design manda dado bancário pro
  provedor de LLM que estiver conectado — inadequado pra esse app, cujo
  dado financeiro é sensível e não deveria trafegar por um serviço de IA
  de terceiro só pra fazer sync de extrato.

## Decisão
Nenhuma integração de Open Finance nesta versão. O caminho pra reduzir
entrada manual de dado é **importação de arquivo OFX/CSV**, decisão que já
estava registrada no Backlog do `docs/ROADMAP.md` antes desta análise —
essa ADR só formaliza o porquê de não seguir a via de API bancária. OFX é
formato estruturado que a maioria dos bancos brasileiros já exporta
(extrato e, em alguns casos, fatura de cartão) via internet banking, sem
precisar de credencial nenhuma além do próprio login do usuário no banco
— ele baixa o arquivo e importa manualmente no app.

## Consequências
- O app continua sem nenhuma dependência de infraestrutura bancária
  regulada — nem CNPJ, nem contrato com agregador, nem chave de API de
  banco. Mantém a superfície de risco/complexidade baixa, coerente com
  "uso privado e doméstico" (`PRODUCT.md`).
- Dado bancário nunca passa por um provedor de LLM ou por qualquer
  terceiro fora do próprio Supabase do usuário — sem a exposição que
  `banco-mcp` introduziria.
- Sincronização não é automática: o usuário precisa baixar o arquivo do
  banco e importar manualmente (import OFX/CSV, ainda não implementado
  nesta sessão — ver Backlog). É mais fricção que uma integração
  automática, mas é o trade-off aceito em troca de não depender de
  licença regulatória.
- Se o produto um dia crescer pra fora do uso doméstico (múltiplos casais/
  famílias, não só um), essa decisão precisa ser revisitada — nesse
  cenário o custo de um agregador (Pluggy/Belvo) passa a fazer sentido
  financeiro, e valeria abrir uma ADR nova (não editar esta).

## Alternativas descartadas
- **Acesso direto ao Open Finance Brasil**: descartado — exige ser
  instituição autorizada pelo Banco Central, inviável pra um app
  desenvolvido por uma pessoa física.
- **Agregador pago (Pluggy, Belvo)**: descartado por ora — resolve o
  problema técnico mas exige CNPJ, contrato e mensalidade recorrente,
  desproporcional pro tamanho do produto (duas pessoas, uso privado).
  Fica registrado como opção pra reconsiderar se o escopo do produto
  mudar.
- **`banco-mcp`**: descartado — é uma ferramenta de assistente de IA
  (servidor MCP), não uma peça de infraestrutura que um app Flutter
  consome; além disso implica mandar dado financeiro sensível por um
  provedor de LLM, o que essa ADR trata como inaceitável pro caso de uso.
- **UPX (`financial-mcp-pf`)** (M7, pesquisado após pedido do usuário por
  um serviço pago barato): descartado pelo mesmo motivo do `banco-mcp`.
  É um servidor MCP — conecta assistentes de IA (Claude, ChatGPT, Cursor)
  a dados bancários via Open Finance, não expõe nenhuma API REST própria
  pra terceiros (a "documentação" só lista os endpoints de descoberta do
  próprio MCP: `openapi.json`, `tools.json`, `.well-known/oauth-...`).
  Não existe forma de um app Flutter consumir isso como backend sem
  passar pela camada de host de IA — mesmo problema de exposição de dado
  bancário sensível já rejeitado acima. Preço (R$34,90–49,90/mês,
  Pessoa Física, sem CNPJ) seria atrativo, mas é irrelevante — o produto
  simplesmente não serve pro caso de uso.
  - De passagem, os preços de mercado dos agregadores citados acima
    foram confirmados/atualizados nesta pesquisa: **Pluggy ~R$2.500/mês,
    Belvo ~R$6.000/mês, Tecnospeed ~R$1.500 de entrada + R$540/mês**
    (relatos de outros desenvolvedores brasileiros construindo apps
    similares em 2026) — reforça o descarte acima com números reais em
    vez de estimativa.
  - Existe uma via gratuita e tecnicamente viável que não chegou a ser
    perseguida: **Meu Pluggy + "Conector 200"** — o usuário conecta a
    própria conta em meu.pluggy.ai (Pluggy como TPP regulado) e o app
    consumiria a API de dados da Pluggy de graça, sem CNPJ nem
    mensalidade. Fica registrado aqui só como referência técnica, não
    como decisão pendente — ver próximo parágrafo.

## Por que a pergunta deixou de fazer sentido
Ao apresentar a comparação acima, ficou claro que o produto **não
precisa** de leitura automática de saldo/extrato bancário — o que
faltava era só registrar entradas, saídas e gastos com cartão, e isso já
está coberto por `#018` (lançamentos avulsos/fixos/variáveis), `#011`
(compra e parcelamento de cartão) e `#023`/`#025` (importação
semi-automática de extrato/fatura via OFX/CSV, sem nenhum terceiro com
acesso à conta). Não é mais "adiado por custo" — é "não necessário".
Este tópico só deve ser reaberto se o produto crescer pra além do uso
doméstico de duas pessoas (cenário já previsto na seção de Consequências
acima).
