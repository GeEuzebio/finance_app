import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/state_views.dart';
import '../../accounts/domain/entities/account.dart';
import '../../accounts/presentation/accounts_providers.dart';
import '../../credit_cards/presentation/cards_screen.dart';
import '../../imports/presentation/import_screen.dart';
import '../../reserves/presentation/reserves_screen.dart';
import 'settings_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _horizonController = TextEditingController();
  final _savingsController = TextEditingController();
  final _balanceController = TextEditingController();
  var _controllersInitialized = false;
  var _balanceControllerInitialized = false;

  @override
  void dispose() {
    _horizonController.dispose();
    _savingsController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final accounts = ref.watch(accountsControllerProvider).valueOrNull ?? const <Account>[];

    if (!_balanceControllerInitialized && accounts.isNotEmpty) {
      _balanceController.text = (accounts.first.initialBalanceCents / 100).toStringAsFixed(2);
      _balanceControllerInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: settingsAsync.when(
        data: (settings) {
          if (!_controllersInitialized) {
            _horizonController.text = settings.projectionHorizonDays.toString();
            _savingsController.text = settings.savingsTargetPercent.toString();
            _controllersInitialized = true;
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionHeader('Aparência'),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Escuro')),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (s) =>
                    ref.read(settingsControllerProvider.notifier).setThemeMode(s.first),
              ),
              const SizedBox(height: 24),
              const _SectionHeader('Projeção'),
              if (accounts.isNotEmpty)
                _MoneyField(
                  label: 'Saldo inicial (R\$)',
                  controller: _balanceController,
                  onSave: (cents) =>
                      ref.read(accountsControllerProvider.notifier).updateInitialBalance(cents),
                ),
              if (accounts.isNotEmpty) const SizedBox(height: 12),
              _NumberField(
                label: 'Horizonte de projeção (dias)',
                controller: _horizonController,
                onSave: (value) =>
                    ref.read(settingsControllerProvider.notifier).setProjectionHorizonDays(value),
              ),
              const SizedBox(height: 24),
              const _SectionHeader('Economia'),
              _NumberField(
                label: 'Meta de economia (%)',
                controller: _savingsController,
                onSave: (value) => ref
                    .read(settingsControllerProvider.notifier)
                    .setSavingsTargetPercent(value),
              ),
              const SizedBox(height: 24),
              const _SectionHeader('Notificações'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_outlined),
                      title: const Text('Lembrete de check-in'),
                      subtitle: Text(
                        settings.checkInReminderEnabled
                            ? 'Todo dia às ${_formatMinutes(settings.checkInReminderMinutes)}'
                            : 'Desligado',
                      ),
                      value: settings.checkInReminderEnabled,
                      onChanged: (value) => _toggleReminder(
                        context,
                        enabled: value,
                        minutes: settings.checkInReminderMinutes,
                      ),
                    ),
                    if (settings.checkInReminderEnabled) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.schedule_outlined),
                        title: const Text('Horário'),
                        trailing: Text(_formatMinutes(settings.checkInReminderMinutes)),
                        onTap: () => _pickTime(context, settings.checkInReminderMinutes),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _SectionHeader('Cartões e reservas'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.credit_card_outlined),
                      title: const Text('Cartões'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CardsScreen()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.savings_outlined),
                      title: const Text('Reservas'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ReservesScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _SectionHeader('Dados'),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: const Text('Importar extrato'),
                  subtitle: const Text('OFX ou CSV'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ImportScreen()),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateView(
          title: 'Não deu pra carregar as configurações',
          message: '$error',
        ),
      ),
    );
  }

  Future<void> _toggleReminder(
    BuildContext context, {
    required bool enabled,
    required int minutes,
  }) async {
    final granted = await ref
        .read(settingsControllerProvider.notifier)
        .setCheckInReminder(enabled: enabled, minutes: minutes);
    if (!granted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissão de notificação negada.')),
      );
    }
  }

  Future<void> _pickTime(BuildContext context, int currentMinutes) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: currentMinutes ~/ 60, minute: currentMinutes % 60),
    );
    if (picked == null || !context.mounted) return;
    await _toggleReminder(
      context,
      enabled: true,
      minutes: picked.hour * 60 + picked.minute,
    );
  }
}

String _formatMinutes(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MoneyField extends StatelessWidget {
  const _MoneyField({required this.label, required this.controller, required this.onSave});

  final String label;
  final TextEditingController controller;
  final void Function(int cents) onSave;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            final amount = double.tryParse(controller.text.replaceAll(',', '.'));
            if (amount != null) onSave((amount * 100).round());
          },
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.controller, required this.onSave});

  final String label;
  final TextEditingController controller;
  final void Function(int value) onSave;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            final value = int.tryParse(controller.text);
            if (value != null && value > 0) onSave(value);
          },
        ),
      ),
    );
  }
}
