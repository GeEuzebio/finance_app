/// Distribui [totalCents] (pode ser negativo, para um débito) em
/// [installments] parcelas; o resíduo de centavos vai para as primeiras
/// parcelas (docs/CASHFLOW_ENGINE.md §3). Ex.: -10000 em 3x ->
/// [-3334, -3333, -3333].
List<int> distributeInstallments(int totalCents, int installments) {
  final sign = totalCents.isNegative ? -1 : 1;
  final absTotal = totalCents.abs();
  final base = absTotal ~/ installments;
  final remainder = absTotal - base * installments;

  return List.generate(
    installments,
    (i) => sign * (i < remainder ? base + 1 : base),
  );
}
