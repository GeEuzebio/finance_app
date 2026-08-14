import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../domain/entities/reserve.dart';
import 'reserves_providers.dart';

class ReservesScreen extends ConsumerWidget {
  const ReservesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservesAsync = ref.watch(reservesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reservas')),
      body: reservesAsync.when(
        data: (reserves) => reserves.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: reserves.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _ReserveCard(reserve: reserves[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: '$error'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateReserveDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateReserveDialog(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final initialController = TextEditingController(text: '0');
    final targetController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nova reserva'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: initialController,
                decoration: const InputDecoration(labelText: 'Valor inicial (R\$)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    double.tryParse((value ?? '').replaceAll(',', '.')) == null
                        ? 'Valor inválido'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: targetController,
                decoration: const InputDecoration(labelText: 'Meta (R\$, opcional)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || value.isEmpty
                    ? null
                    : (double.tryParse(value.replaceAll(',', '.')) == null
                        ? 'Valor inválido'
                        : null),
              ),
            ],
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

              final targetText = targetController.text;
              final reserve = Reserve(
                id: const Uuid().v4(),
                name: nameController.text,
                currentAmountCents:
                    (double.parse(initialController.text.replaceAll(',', '.')) * 100).round(),
                targetAmountCents: targetText.isEmpty
                    ? null
                    : (double.parse(targetText.replaceAll(',', '.')) * 100).round(),
                createdAt: DateTime.now(),
              );

              await ref.read(reservesControllerProvider.notifier).createReserve(reserve);
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

class _ReserveCard extends ConsumerWidget {
  const _ReserveCard({required this.reserve});

  final Reserve reserve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final target = reserve.targetAmountCents;
    final progress = (target != null && target > 0)
        ? (reserve.currentAmountCents / target).clamp(0.0, 1.0)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reserve.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  target != null
                      ? '${formatCents(reserve.currentAmountCents)} / ${formatCents(target)}'
                      : formatCents(reserve.currentAmountCents),
                  style: AppTheme.money(theme.textTheme.bodyLarge),
                ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Excluir',
                  icon: Icon(Icons.delete_outline, color: AppColors.debit(theme.brightness)),
                  onPressed: () => _confirmDelete(context, ref),
                ),
                IconButton(
                  tooltip: 'Resgatar',
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _showAmountDialog(
                    context,
                    ref,
                    title: 'Resgatar',
                    onConfirm: (cents) => ref
                        .read(reservesControllerProvider.notifier)
                        .withdraw(reserve.id, cents),
                  ),
                ),
                IconButton(
                  tooltip: 'Aportar',
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showAmountDialog(
                    context,
                    ref,
                    title: 'Aportar',
                    onConfirm: (cents) => ref
                        .read(reservesControllerProvider.notifier)
                        .contribute(reserve.id, cents),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir reserva?'),
        content: Text('"${reserve.name}" será removida. Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(reservesControllerProvider.notifier).deleteReserve(reserve.id);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  Future<void> _showAmountDialog(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required Future<void> Function(int cents) onConfirm,
  }) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Valor (R\$)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final v = double.tryParse((value ?? '').replaceAll(',', '.'));
              return (v == null || v <= 0) ? 'Valor inválido' : null;
            },
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
              final cents =
                  (double.parse(controller.text.replaceAll(',', '.')) * 100).round();
              Navigator.of(dialogContext).pop();
              try {
                await onConfirm(cents);
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('$error')));
                }
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = AppColors.textMuted(theme.brightness);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.savings_outlined, size: 48, color: muted),
            const SizedBox(height: 16),
            Text(
              'Nenhuma reserva ainda',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie uma reserva pra separar dinheiro de um objetivo sem tirar do seu saldo livre.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.debit(theme.brightness)),
            const SizedBox(height: 16),
            Text(
              'Não deu pra carregar suas reservas',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textMuted(theme.brightness)),
            ),
          ],
        ),
      ),
    );
  }
}
