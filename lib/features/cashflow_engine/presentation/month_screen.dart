import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/state_views.dart';
import '../domain/entities/monthly_summary.dart';
import 'month_providers.dart';

class MonthScreen extends ConsumerWidget {
  const MonthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlySummaryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_formatMonthTitle())),
      body: summaryAsync.when(
        data: (summary) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionCard(
              title: 'Performance',
              children: [
                _MetricRow(label: 'Entradas', cents: summary.incomeCents, isCredit: true),
                _MetricRow(label: 'Saídas', cents: -summary.expensesCents, isCredit: false),
                _MetricRow(
                  label: 'Custo diário',
                  cents: -summary.dailyCostCents,
                  isCredit: false,
                ),
                _MetricRow(label: 'Economizado', cents: summary.savedCents, isCredit: true),
                _MetricRow(
                  label: 'Gastos com cartão',
                  cents: -summary.cardSpendCents,
                  isCredit: false,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _EconomySection(summary: summary),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Custo de vida',
              children: [
                _MetricRow(label: 'Saídas', cents: -summary.expensesCents, isCredit: false),
                _MetricRow(
                  label: 'Custo diário',
                  cents: -summary.dailyCostCents,
                  isCredit: false,
                ),
                _MetricRow(
                  label: 'Gastos com cartão',
                  cents: -summary.cardSpendCents,
                  isCredit: false,
                ),
                const Divider(height: 24),
                _MetricRow(
                  label: 'Total',
                  cents: -summary.costOfLivingCents,
                  isCredit: false,
                  emphasized: true,
                ),
              ],
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateView(
          title: 'Não deu pra calcular o mês',
          message: '$error',
        ),
      ),
    );
  }

  String _formatMonthTitle() {
    final formatted = DateFormat('MMMM \'de\' yyyy', 'pt_BR').format(DateTime.now());
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.cents,
    required this.isCredit,
    this.emphasized = false,
  });

  final String label;
  final int cents;
  final bool isCredit;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCredit
        ? AppColors.credit(theme.brightness)
        : AppColors.debit(theme.brightness);
    final labelStyle = emphasized
        ? theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)
        : theme.textTheme.bodyMedium
            ?.copyWith(color: AppColors.textMuted(theme.brightness));
    final valueStyle = emphasized
        ? AppTheme.money(theme.textTheme.titleMedium)
        : AppTheme.money(theme.textTheme.bodyMedium);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(formatCents(cents), style: valueStyle.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _EconomySection extends StatelessWidget {
  const _EconomySection({required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnTarget = summary.isSavingsOnTarget;
    final badgeColor = isOnTarget ? AppColors.credit(theme.brightness) : AppColors.debit(theme.brightness);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Economia',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isOnTarget ? 'Ideal' : 'Abaixo do ideal',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: badgeColor, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              formatCents(summary.savedCents),
              style: AppTheme.money(theme.textTheme.headlineSmall).copyWith(color: badgeColor),
            ),
            const SizedBox(height: 4),
            Text(
              '${summary.savingsPercent.toStringAsFixed(1)}% da renda do mês',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textMuted(theme.brightness)),
            ),
          ],
        ),
      ),
    );
  }
}
