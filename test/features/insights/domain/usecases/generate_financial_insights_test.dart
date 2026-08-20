import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/core/utils/transaction_category.dart';
import 'package:finance_app/features/insights/domain/entities/financial_insights.dart';
import 'package:finance_app/features/insights/domain/repositories/insights_repository.dart';
import 'package:finance_app/features/insights/domain/usecases/generate_financial_insights.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockInsightsRepository extends Mock implements InsightsRepository {}

void main() {
  late _MockInsightsRepository repository;
  late GenerateFinancialInsights useCase;

  const InsightsRequestData data = (
    categoryCents: {TransactionCategory.alimentacao: 30000},
    necessidadesCents: 50000,
    desejosCents: 20000,
    reservaCents: 10000,
    savedCents: 10000,
    savingsPercent: 12.5,
    overdueCents: 0,
  );

  setUp(() {
    repository = _MockInsightsRepository();
    useCase = GenerateFinancialInsights(repository);
  });

  test('repassa o payload pro repositório e devolve as sugestões', () async {
    final insights =
        FinancialInsights(suggestions: const ['s1', 's2', 's3'], generatedAt: DateTime(2026));
    when(() => repository.generate(data)).thenAnswer((_) async => Right(insights));

    final result = await useCase(data);

    expect(result.getOrElse((_) => throw StateError('esperava Right')), insights);
    verify(() => repository.generate(data)).called(1);
  });

  test('propaga a falha do repositório', () async {
    when(() => repository.generate(data))
        .thenAnswer((_) async => const Left(DatabaseFailure('edge function falhou')));

    final result = await useCase(data);

    result.match((l) => expect(l, isA<DatabaseFailure>()), (r) => fail('esperava Left'));
  });
}
