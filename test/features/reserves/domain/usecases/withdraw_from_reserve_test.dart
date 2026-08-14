import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/features/reserves/domain/entities/reserve.dart';
import 'package:finance_app/features/reserves/domain/repositories/reserve_repository.dart';
import 'package:finance_app/features/reserves/domain/usecases/withdraw_from_reserve.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockReserveRepository extends Mock implements ReserveRepository {}

void main() {
  late _MockReserveRepository repository;
  late WithdrawFromReserve useCase;

  final reserve = Reserve(
    id: 'r1',
    name: 'Emergência',
    currentAmountCents: 5000,
    createdAt: DateTime(2026),
  );

  setUpAll(() => registerFallbackValue(reserve));

  setUp(() {
    repository = _MockReserveRepository();
    useCase = WithdrawFromReserve(repository);
    when(() => repository.getById('r1')).thenAnswer((_) async => Right(reserve));
    when(() => repository.upsert(any())).thenAnswer((_) async => const Right(unit));
  });

  test('decrementa currentAmountCents', () async {
    final result = await useCase(reserveId: 'r1', amountCents: 2000);

    expect(result.isRight(), isTrue);
    final captured = verify(() => repository.upsert(captureAny())).captured.single as Reserve;
    expect(captured.currentAmountCents, 3000);
  });

  test('rejeita resgate maior que o saldo da reserva', () async {
    final result = await useCase(reserveId: 'r1', amountCents: 5001);

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });

  test('rejeita resgate não positivo', () async {
    final result = await useCase(reserveId: 'r1', amountCents: 0);

    result.match((l) => expect(l, isA<ValidationFailure>()), (r) => fail('esperava Left'));
    verifyNever(() => repository.upsert(any()));
  });
}
