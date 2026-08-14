import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/accounts/presentation/accounts_screen.dart';
import 'features/cashflow_engine/presentation/projection_screen.dart';
import 'features/credit_cards/presentation/cards_screen.dart';
import 'features/reserves/presentation/reserves_screen.dart';
import 'features/transactions/presentation/check_in_screen.dart';

// Preenchidos em tempo de compilação via `--dart-define-from-file=.env`
// (recurso nativo do Flutter — flutter run/build --dart-define-from-file=.env).
// ⚠️ Nunca leia SUPABASE_SERVICE_ROLE_KEY aqui nem em nenhum outro lugar de
// lib/: essa chave tem privilégio total e não pode ir para um app cliente.
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  await Supabase.initialize(url: _supabaseUrl, publishableKey: _supabaseAnonKey);
  configureDependencies();
  runApp(const ProviderScope(child: _App()));
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const _HomeShell(),
    );
  }
}

/// Navegação por abas — 2 telas hoje (Contas, Projeção), extensível pras
/// próximas do M6 (Check-in, Cartões, Reservas). Tab bar é o padrão nativo
/// pra 2-5 seções de topo (docs/DESIGN.md — modo Operate).
class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  var _index = 0;

  static const _screens = [
    AccountsScreen(),
    ProjectionScreen(),
    CheckInScreen(),
    CardsScreen(),
    ReservesScreen(),
  ];
  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.account_balance_outlined), label: 'Contas'),
    NavigationDestination(icon: Icon(Icons.trending_up), label: 'Projeção'),
    NavigationDestination(icon: Icon(Icons.task_alt_outlined), label: 'Check-in'),
    NavigationDestination(icon: Icon(Icons.credit_card_outlined), label: 'Cartões'),
    NavigationDestination(icon: Icon(Icons.savings_outlined), label: 'Reservas'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _destinations,
      ),
    );
  }
}
