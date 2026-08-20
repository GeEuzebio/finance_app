import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/transaction_category.dart';
import '../../../core/widgets/state_views.dart';
import '../../insights/presentation/insights_providers.dart';
import '../../settings/presentation/settings_providers.dart';
import '../domain/entities/monthly_summary.dart';
import '../domain/monthly_summary.dart' show budget503020;
import 'month_providers.dart';

class MonthScreen extends ConsumerWidget {
  const MonthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlySummaryProvider);
    final overdueCents = ref.watch(overdueCardDebtProvider).valueOrNull ?? 0;

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
            _Budget503020Card(summary: summary),
            if (overdueCents < 0) ...[
              const SizedBox(height: 16),
              _PayoffPlanCard(overdueCents: overdueCents),
            ],
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
            if (summary.categoryCents.isNotEmpty) ...[
              const SizedBox(height: 16),
              _CategoryBreakdownCard(summary: summary),
            ],
            const SizedBox(height: 16),
            const _InsightsCard(),
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

/// "Pra onde vai meu dinheiro" — M7, #029. Reusa `categoryCents`, que já
/// bate com `costOfLivingCents` (mesma composição), sem cálculo próprio
/// aqui, só ordenação e apresentação.
class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = summary.costOfLivingCents;
    final entries = summary.categoryCents.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gastos por categoria',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(categoryIcon(entry.key),
                            size: 16, color: AppColors.textMuted(theme.brightness)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(categoryLabel(entry.key), style: theme.textTheme.bodyMedium),
                        ),
                        Text(
                          formatCents(entry.value),
                          style: AppTheme.money(theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : entry.value / total,
                        minHeight: 4,
                        backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                        valueColor: AlwaysStoppedAnimation(AppColors.debit(theme.brightness)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Guia 50/30/20 (M7, #029) — necessidades/desejos/reserva já vêm
/// calculados de `budget503020`, sem lógica de negócio aqui.
class _Budget503020Card extends StatelessWidget {
  const _Budget503020Card({required this.summary});

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final budget = budget503020(summary);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guia 50/30/20',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _BudgetRow(
              label: 'Necessidades',
              targetPercent: 50,
              actualPercent: budget.necessidadesPercent,
              cents: budget.necessidadesCents,
              overTargetIsBad: true,
            ),
            _BudgetRow(
              label: 'Desejos',
              targetPercent: 30,
              actualPercent: budget.desejosPercent,
              cents: budget.desejosCents,
              overTargetIsBad: true,
            ),
            _BudgetRow(
              label: 'Reserva',
              targetPercent: 20,
              actualPercent: budget.reservaPercent,
              cents: budget.reservaCents,
              overTargetIsBad: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({
    required this.label,
    required this.targetPercent,
    required this.actualPercent,
    required this.cents,
    required this.overTargetIsBad,
  });

  final String label;
  final int targetPercent;
  final double actualPercent;
  final int cents;
  final bool overTargetIsBad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGood =
        overTargetIsBad ? actualPercent <= targetPercent : actualPercent >= targetPercent;
    final color = isGood ? AppColors.credit(theme.brightness) : AppColors.debit(theme.brightness);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$label · meta $targetPercent%', style: theme.textTheme.bodyMedium),
              Text(
                '${actualPercent.toStringAsFixed(0)}% · ${formatCents(cents)}',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (actualPercent / 100).clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Plano de quitação de fatura atrasada (M7, #029) — só aparece quando
/// `GetOverdueCardDebt` acha rotativo de verdade (fatura vencida, não
/// paga). Horizonte fixo de 3 meses (ponytail: MVP, sem input de prazo —
/// adicionar um seletor de meses se o horizonte fixo não servir).
class _PayoffPlanCard extends StatelessWidget {
  const _PayoffPlanCard({required this.overdueCents});

  final int overdueCents;

  static const _horizonMonths = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.debit(theme.brightness);
    final monthlyCents = (-overdueCents / _horizonMonths).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 18, color: color),
                const SizedBox(width: 8),
                Text(
                  'Fatura atrasada',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${formatCents(overdueCents)} em rotativo. Pagando '
              '${formatCents(monthlyCents)} a mais por mês, zera em $_horizonMonths meses.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
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

/// Sugestões de IA sob demanda (M7, #031) — opt-in em Configurações; sem
/// o toggle ligado, mostra um convite mudo em vez do botão.
class _InsightsCard extends ConsumerStatefulWidget {
  const _InsightsCard();

  @override
  ConsumerState<_InsightsCard> createState() => _InsightsCardState();
}

class _InsightsCardState extends ConsumerState<_InsightsCard> {
  var _isBusy = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = AppColors.textMuted(theme.brightness);
    final enabled = ref.watch(settingsControllerProvider).valueOrNull?.aiInsightsEnabled ?? false;

    if (!enabled) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_outlined, size: 18, color: muted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ative "Sugestões por IA" em Configurações pra receber conselhos '
                  'sobre como reduzir gastos e economizar mais.',
                  style: theme.textTheme.bodySmall?.copyWith(color: muted),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final insights = ref.watch(insightsControllerProvider);

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
                  'Sugestões da IA',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: _isBusy ? null : _generate,
                  child: Text(
                    _isBusy ? 'Gerando...' : (insights == null ? 'Gerar sugestões' : 'Atualizar'),
                  ),
                ),
              ],
            ),
            if (insights != null) ...[
              const SizedBox(height: 8),
              for (final suggestion in insights.suggestions)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('•  $suggestion', style: theme.textTheme.bodyMedium),
                ),
            ],
            const SizedBox(height: 8),
            Text(
              'Dados agregados por categoria enviados à Anthropic — nenhum '
              'lançamento individual é compartilhado.',
              style: theme.textTheme.labelSmall?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    setState(() => _isBusy = true);
    try {
      await ref.read(insightsControllerProvider.notifier).generate();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }
}
