import 'package:finance_app/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUp(() async {
    getIt.reset();
    // Supabase guarda a sessão local via shared_preferences — em teste de
    // VM não há platform channel de verdade, então mockamos vazio.
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      publishableKey: 'test-anon-key',
    );
  });

  test('container resolve sem erro', () {
    configureDependencies();

    expect(() => getIt<SupabaseClient>(), returnsNormally);
  });
}
