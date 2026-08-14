import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  // Supabase.initialize() já roda antes de configureDependencies() em
  // main.dart — aqui só expomos a instância para o container de DI.
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
