import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../domain/entities/daily_balance.dart';
import 'projection_providers.dart';

class ProjectionScreen extends ConsumerWidget {
  const ProjectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectionAsync = ref.watch(dailyProjectionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Projeção')),
      body: projectionAsync.when(
        data: (balances) {
          final consolidated = balances.where((b) => b.accountId == null).toList()
            ..sort((a, b) => a.date.compareTo(b.date));
          if (consolidated.isEmpty) return const _EmptyProjectionState();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: consolidated.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _DayRow(balance: consolidated[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: '$error'),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.balance});

  final DailyBalance balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = balance.date == DateOnly.fromDateTime(DateTime.now());
    final isNegative = balance.closingBalanceCents < 0;
    final moneyColor =
        isNegative ? AppColors.debit(theme.brightness) : theme.colorScheme.onSurface;
    final showFreeBalance = balance.freeBalanceCents != null &&
        balance.freeBalanceCents != balance.closingBalanceCents;

    return Card(
      color: isNegative
          ? AppColors.debit(theme.brightness).withValues(alpha: 0.08)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (isNegative)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.debit(theme.brightness),
                  size: 20,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(_formatDate(balance.date), style: theme.textTheme.titleSmall),
                      if (isToday) ...[
                        const SizedBox(width: 8),
                        const _TodayChip(),
                      ],
                    ],
                  ),
                  if (showFreeBalance) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Livre: ${formatCents(balance.freeBalanceCents!)}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              formatCents(balance.closingBalanceCents),
              style: AppTheme.money(theme.textTheme.titleMedium).copyWith(color: moneyColor),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateOnly date) =>
      DateFormat('EEE, d MMM', 'pt_BR').format(date.toDateTime());
}

class _TodayChip extends StatelessWidget {
  const _TodayChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.amber,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'HOJE',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onAmber,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _EmptyProjectionState extends StatelessWidget {
  const _EmptyProjectionState();

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
            Icon(Icons.trending_up, size: 48, color: muted),
            const SizedBox(height: 16),
            Text(
              'Nenhuma previsão ainda',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Cadastre uma conta na aba Contas pra começar a ver seu saldo previsto.',
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
              'Não deu pra calcular sua previsão',
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
