import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/accounts/domain/repositories/account_repository.dart';
import 'features/accounts/presentation/accounts_providers.dart';
import 'features/cashflow_engine/presentation/month_screen.dart';
import 'features/cashflow_engine/presentation/projection_screen.dart';
import 'features/notifications/notification_service.dart';
import 'features/settings/presentation/settings_providers.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/transactions/presentation/check_in_screen.dart';
import 'features/transactions/presentation/lancamentos_screen.dart';

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
  await getIt<NotificationService>().initialize();
  await ensureDefaultAccount(getIt<AccountRepository>());
  runApp(const ProviderScope(child: _App()));
}

class _App extends ConsumerWidget {
  const _App();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode =
        ref.watch(settingsControllerProvider).valueOrNull?.themeMode ?? ThemeMode.system;

    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const _HomeShell(),
    );
  }
}

/// Navegação por abas — Contas, Cartões e Reservas moraram aqui até o M7;
/// agora vivem dentro de Configurações (`SettingsScreen`), que também
/// reúne tema, horizonte de projeção e meta de economia. Tab bar é o
/// padrão nativo pra 2-5 seções de topo (docs/DESIGN.md — modo Operate).
class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  var _index = 0;

  static const _screens = [
    ProjectionScreen(),
    LancamentosScreen(),
    CheckInScreen(),
    MonthScreen(),
    SettingsScreen(),
  ];
  static const _destinations = [
    (icon: Icons.trending_up, label: 'Projeção'),
    (icon: Icons.receipt_long_outlined, label: 'Lançamentos'),
    (icon: Icons.task_alt_outlined, label: 'Check-in'),
    (icon: Icons.calendar_month_outlined, label: 'Mês'),
    (icon: Icons.settings_outlined, label: 'Configurações'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: _destinations.length,
        activeIndex: _index,
        onTap: (i) => setState(() => _index = i),
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: theme.colorScheme.surface,
        splashColor: AppColors.amber.withValues(alpha: 0.2),
        // Só ícones — os rótulos continuam via Semantics pra leitor de
        // tela, só não aparecem visualmente.
        tabBuilder: (index, isActive) {
          final destination = _destinations[index];
          return Semantics(
            label: destination.label,
            selected: isActive,
            button: true,
            child: Icon(
              destination.icon,
              color: isActive ? AppColors.amber : AppColors.textMuted(theme.brightness),
            ),
          );
        },
      ),
    );
  }
}
