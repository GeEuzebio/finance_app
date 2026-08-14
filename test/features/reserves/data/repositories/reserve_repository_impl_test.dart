import 'package:finance_app/core/database/app_database.dart' hide Reserve;
import 'package:finance_app/core/database/connection.dart';
import 'package:finance_app/core/errors/failure.dart';
import 'package:finance_app/features/reserves/data/repositories/reserve_repository_impl.dart';
import 'package:finance_app/features/reserves/domain/entities/reserve.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ReserveRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(openTestConnection());
    repository = ReserveRepositoryImpl(db.reservesDao);
  });
  tearDown(() => db.close());

  Reserve buildReserve(String id) => Reserve(
        id: id,
        name: 'Emergência',
        currentAmountCents: 50000,
        createdAt: DateTime(2026, 1, 1),
      );

  test('upsert + getAll + getById + delete roundtrip via Either', () async {
    expect((await repository.upsert(buildReserve('r1'))).isRight(), isTrue);

    final all = await repository.getAll();
    all.match((l) => fail('esperava Right, recebeu $l'), (r) => expect(r.single.id, 'r1'));

    expect((await repository.delete('r1')).isRight(), isTrue);
    final afterDelete = await repository.getById('r1');
    afterDelete.match((l) => expect(l, isA<NotFoundFailure>()), (r) => fail('esperava Left'));
  });
}
