import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/state_views.dart';
import '../../transactions/domain/entities/check_in_item.dart';
import 'projection_providers.dart';

/// Detalhamento de um dia da Projeção (M7, #026) — todas as entradas e
/// saídas que compõem a "Diferença" daquela linha da grade.
class DayDetailScreen extends ConsumerWidget {
  const DayDetailScreen({required this.date, super.key});

  final DateOnly date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(dayLedgerProvider(day: date));

    return Scaffold(
      appBar: AppBar(title: Text(_formatFullDate(date))),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyStateView(
              icon: Icons.event_note_outlined,
              title: 'Nenhum movimento',
              message: 'Não há entradas nem saídas previstas pra este dia.',
            );
          }
          final totalCents = items.fold(0, (sum, item) => sum + item.amountCents);
          return Column(
            children: [
              _TotalBanner(totalCents: totalCents),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _LedgerCard(item: items[index]),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateView(
          title: 'Não deu pra carregar este dia',
          message: '$error',
        ),
      ),
    );
  }

  String _formatFullDate(DateOnly date) {
    final formatted = DateFormat('d \'de\' MMMM', 'pt_BR').format(date.toDateTime());
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

class _TotalBanner extends StatelessWidget {
  const _TotalBanner({required this.totalCents});

  final int totalCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = totalCents == 0
        ? AppColors.textMuted(theme.brightness)
        : (totalCents > 0
            ? AppColors.credit(theme.brightness)
            : AppColors.debit(theme.brightness));

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Diferença do dia', style: theme.textTheme.bodyMedium?.copyWith(color: color)),
          Text(
            formatCents(totalCents),
            style: AppTheme.money(theme.textTheme.titleMedium).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _LedgerCard extends StatelessWidget {
  const _LedgerCard({required this.item});

  final CheckInItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = item.amountCents < 0;
    final moneyColor =
        isNegative ? AppColors.debit(theme.brightness) : AppColors.credit(theme.brightness);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
      ),
    );
  }
}
