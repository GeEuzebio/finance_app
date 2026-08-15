import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/state_views.dart';
import '../domain/entities/check_in_item.dart';
import 'check_in_providers.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(checkInControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: itemsAsync.when(
        data: (items) => items.isEmpty
            ? const EmptyStateView(
                icon: Icons.task_alt,
                title: 'Tudo em dia',
                message: 'Nada previsto pra hoje que ainda precise de check-in.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _CheckInCard(item: items[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateView(
          title: 'Não deu pra carregar o check-in de hoje',
          message: '$error',
        ),
      ),
    );
  }
}

class _CheckInCard extends ConsumerWidget {
  const _CheckInCard({required this.item});

  final CheckInItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isNegative = item.amountCents < 0;
    final moneyColor =
        isNegative ? AppColors.debit(theme.brightness) : theme.colorScheme.onSurface;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.accountName,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatCents(item.amountCents),
                  style: AppTheme.money(theme.textTheme.titleMedium).copyWith(color: moneyColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Cancelar',
                  icon: Icon(Icons.close, color: AppColors.debit(theme.brightness)),
                  onPressed: () => _run(context, ref, () => ref
                      .read(checkInControllerProvider.notifier)
                      .cancel(item)),
                ),
                IconButton(
                  tooltip: 'Adiar',
                  icon: const Icon(Icons.event_repeat_outlined),
                  onPressed: () => _showPostponeDialog(context, ref),
                ),
                IconButton(
                  tooltip: 'Ajustar valor',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _showAdjustDialog(context, ref),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Confirmar'),
                  onPressed: () => _run(context, ref, () => ref
                      .read(checkInControllerProvider.notifier)
                      .confirm(item)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  Future<void> _showAdjustDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: (item.amountCents / 100).toStringAsFixed(2));
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ajustar valor'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Valor (R\$)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) =>
                double.tryParse((value ?? '').replaceAll(',', '.')) == null
                    ? 'Valor inválido'
                    : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final signal = item.amountCents < 0 ? -1 : 1;
              final newAmount =
                  (double.parse(controller.text.replaceAll(',', '.')) * 100).round().abs() *
                      signal;
              Navigator.of(dialogContext).pop();
              await _run(
                context,
                ref,
                () => ref.read(checkInControllerProvider.notifier).adjust(item, newAmount),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPostponeDialog(BuildContext context, WidgetRef ref) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: item.date.toDateTime().add(const Duration(days: 1)),
      firstDate: item.date.toDateTime(),
      lastDate: item.date.toDateTime().add(const Duration(days: 365)),
    );
    if (newDate == null || !context.mounted) return;
    await _run(
      context,
      ref,
      () => ref
          .read(checkInControllerProvider.notifier)
          .postpone(item, DateOnly.fromDateTime(newDate)),
    );
  }
}

