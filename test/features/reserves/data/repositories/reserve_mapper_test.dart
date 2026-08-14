import 'package:finance_app/features/reserves/data/repositories/reserve_repository_impl.dart';
import 'package:finance_app/features/reserves/domain/entities/reserve.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reserveFromJson(reserveToJson(x)) faz roundtrip, com targetAmountCents nulo', () {
    final reserve = Reserve(
      id: 'r1',
      name: 'Emergência',
      currentAmountCents: 50000,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    expect(reserveFromJson(reserveToJson(reserve)), reserve);
  });

  test('reserveFromJson(reserveToJson(x)) preserva a meta quando definida', () {
    final reserve = Reserve(
      id: 'r2',
      name: 'Viagem',
      targetAmountCents: 500000,
      currentAmountCents: 120000,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    expect(reserveFromJson(reserveToJson(reserve)), reserve);
  });
}
