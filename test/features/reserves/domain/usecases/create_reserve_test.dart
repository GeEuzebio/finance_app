import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/features/reserves/domain/entities/reserve.dart';
import 'package:finance_app/features/reserves/domain/repositories/reserve_repository.dart';
import 'package:finance_app/features/reserves/domain/usecases/create_reserve.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockReserveRepository extends Mock implements ReserveRepository {}

void main() {
  late _MockReserveRepository repository;
  late CreateReserve useCase;

  Reserve buildReserve({int currentAmountCents = 0, int? targetAmountCents}) => Reserve(
        id: 'r1',
        name: 'Emergência',
        currentAmountCents: currentAmountCents,
        targetAmountCents: targetAmountCents,
        createdAt: DateTime(2026),
      );

  setUpAll(() => registerFallbackValue(buildReserve()));

  setUp(() {
    repository = _MockReserveRepository();
    useCase = CreateReserve(repository);
  });

  test('reserva válida é persistida via repository.upsert', () async {
    final reserve = buildReserve(currentAmountCents: 5000, targetAmountCents: 100000);
    when(() => repository.upsert(reserve)).thenAnswer((_) async => const Right(unit));

    final result = await useCase(reserve);

    expect(result.isRight(), isTrue);
    verify(() => repository.upsert(reserve)).called(1);
  });

  test('rejeita currentAmountCents negativo sem chamar o repositório', () async {
    final result = await useCase(buildReserve(currentAmountCents: -1));

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });

  test('rejeita targetAmountCents negativo sem chamar o repositório', () async {
    final result = await useCase(buildReserve(targetAmountCents: -1));

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });
}
