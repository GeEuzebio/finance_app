import 'package:finance_app/core/database/app_database.dart';
import 'package:finance_app/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() => getIt.reset());

  test('container resolve sem erro', () {
    configureDependencies();

    expect(() => getIt<AppDatabase>(), returnsNormally);
  });
}
