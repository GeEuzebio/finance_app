# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Users

Um casal (duas pessoas) usando o mesmo app em aparelhos separados, sem
login — dataset único e compartilhado via Supabase (mesma
`SUPABASE_ANON_KEY` nos dois aparelhos). Perfil: pessoas que já têm o
hábito de acompanhar as próprias finanças e querem responder "quanto vou
ter no banco daqui a X dias", não só "quanto já gastei até agora".

## Product Purpose

App de finanças pessoais cujo diferencial é previsibilidade de saldo
futuro, não categorização do passado. Calcula o saldo previsto de cada dia
dos próximos meses a partir do saldo conciliado da conta + lançamentos
recorrentes + lançamentos pontuais futuros + faturas de cartão projetadas.

## Positioning

Concorrentes (apps de categorização de gasto) respondem "onde você
gastou"; este responde "quanto você vai ter no banco no dia 17 do mês que
vem". O mecanismo central é uma engine de projeção diária pura e
determinística (`docs/CASHFLOW_ENGINE.md`), não um extrato categorizado.

## Operating Context

Quatro fluxos centrais e recorrentes:

- **Projeção diária** — ver o saldo previsto de cada dia dos próximos meses.
- **Check-in diário** — confirmar, ajustar, adiar ou cancelar o que estava
  previsto para hoje.
- **Gestão de cartão** — fatura montada a partir de fechamento/vencimento +
  compras (à vista ou parceladas).
- **Reservas/objetivos** — valor reservado, recortado do saldo livre sem
  ser despesa.

Uso é privado e doméstico — sem onboarding de múltiplos clientes, sem
fluxo de convite; as duas pessoas compartilham a mesma sessão/chave.

## Capabilities and Constraints

- Dinheiro sempre inteiro em centavos, nunca ponto flutuante.
- Datas de lançamento sem hora (fuso America/Sao_Paulo).
- Persistência: Supabase/Postgres compartilhado (ADR 0005) — sem modo
  offline nesta versão, o app exige internet.
- Sem autenticação nesta versão — RLS ligado com política permissiva,
  mesma anon key para os dois usuários (ver `supabase/schema.sql`).
- Stack: Flutter/Dart, Riverpod (estado), get_it/injectable (DI),
  `Either<Failure, T>` via fpdart (erros).
- Horizonte de projeção padrão: 12 meses.
- Plataforma "adaptive" aqui não significa Material no Android / Cupertino
  no iOS: é uma identidade visual própria e única, consistente nos dois
  SOs (decisão confirmada no init) — o valor "adaptive" só está registrado
  para carregar as referências nativas de ergonomia (safe area, gestos,
  haptics) de ambos os sistemas, não para adaptar a skin visual por SO.

## Brand Commitments

Nenhum ainda — nome de exibição, logo e paleta estão em aberto (confirmado
no init). "Finance App"/`finance_app` é só o nome técnico do pacote
Flutter (`pubspec.yaml`), não uma decisão de marca.

## Evidence on Hand

Nenhum dado real além de testes manuais — banco Supabase recém-criado,
sem contas/lançamentos reais ainda. Nenhuma tela de feature com visual
próprio existe hoje: só uma lista de contas mínima
(`lib/features/accounts/presentation/accounts_screen.dart`) em Material
padrão, sem tema customizado.

## Product Principles

1. Previsibilidade > histórico — toda decisão de UI prioriza "o que vai
   acontecer" sobre "o que já aconteceu".
2. Confiança em dinheiro — nunca arredondar de um jeito que o total exibido
   não bata com a soma exata dos centavos; valores sempre exatos.
3. Uso a dois sem fricção — nada de login, convite ou configuração de
   perfil; qualquer tela assume que pode ser aberta indiferentemente por
   qualquer uma das duas pessoas.
4. Uma identidade visual, dois SOs — marca visual própria, não uma skin
   nativa diferente por sistema operacional.

## Accessibility & Inclusion

Nenhum requisito específico além dos padrões básicos de contraste e alvo
de toque adequado — dado financeiro é sensível e às vezes consultado sob
estresse, então clareza tem prioridade sobre densidade de informação.
