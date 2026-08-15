import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/state_views.dart';
import '../../accounts/domain/entities/account.dart';
import '../../accounts/presentation/accounts_providers.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../../transactions/presentation/lancamentos_providers.dart';
import '../domain/entities/daily_balance.dart';
import 'day_detail_screen.dart';
import 'projection_providers.dart';

class ProjectionScreen extends ConsumerStatefulWidget {
  const ProjectionScreen({super.key});

  @override
  ConsumerState<ProjectionScreen> createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends ConsumerState<ProjectionScreen> {
  var _month = DateOnly.fromDateTime(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final projectionAsync =
        ref.watch(monthlyProjectionProvider(year: _month.year, month: _month.month));
    final today = DateOnly.fromDateTime(DateTime.now());
    final isCurrentMonth = _month.year == today.year && _month.month == today.month;

    return Scaffold(
      appBar: AppBar(title: const Text('Projeção')),
      body: Column(
        children: [
          _MonthSelector(
            month: _month,
            onChanged: (m) => setState(() => _month = m),
          ),
          if (isCurrentMonth) const _CommittedCardBanner(),
          Expanded(
            child: projectionAsync.when(
              data: (balances) {
                final consolidated = balances.where((b) => b.accountId == null).toList()
                  ..sort((a, b) => a.date.compareTo(b.date));
                if (consolidated.isEmpty) {
                  return const EmptyStateView(
                    icon: Icons.trending_up,
                    title: 'Nenhuma previsão ainda',
                    message:
                        'Cadastre uma conta em Configurações pra começar a ver seu saldo previsto.',
                  );
                }
                final scaleCents = consolidated
                    .map((b) => b.closingBalanceCents.abs())
                    .fold(0, (max, v) => v > max ? v : max);
                return Column(
                  children: [
                    const _HeaderRow(),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: consolidated.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => _DayRow(
                          key: ValueKey(consolidated[index].date),
                          balance: consolidated[index],
                          scaleCents: scaleCents,
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorStateView(
                title: 'Não deu pra calcular sua previsão',
                message: '$error',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Adicionar movimento',
        onPressed: () => _openAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openAddDialog(BuildContext context) async {
    final accounts = ref.read(accountsControllerProvider).valueOrNull ?? const <Account>[];
    if (accounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crie uma conta antes de lançar um movimento.')),
      );
      return;
    }

    final today = DateOnly.fromDateTime(DateTime.now());
    final isCurrentMonth = _month.year == today.year && _month.month == today.month;
    var date = isCurrentMonth ? today : DateOnly(_month.year, _month.month, 1);
    var accountId = accounts.first.id;
    var isEntrada = false;
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Novo movimento'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Data: ${_formatDate(date)}')),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: dialogContext,
                            initialDate: date.toDateTime(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          );
                          if (picked != null) {
                            setDialogState(() => date = DateOnly.fromDateTime(picked));
                          }
                        },
                        child: const Text('Alterar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: accountId,
                    decoration: const InputDecoration(labelText: 'Conta'),
                    items: accounts
                        .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => accountId = value ?? accountId),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<bool>(
                          initialValue: isEntrada,
                          decoration: const InputDecoration(labelText: 'Tipo de valor'),
                          items: const [
                            DropdownMenuItem(value: false, child: Text('Saída')),
                            DropdownMenuItem(value: true, child: Text('Entrada')),
                          ],
                          onChanged: (value) =>
                              setDialogState(() => isEntrada = value ?? isEntrada),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            final amount = double.tryParse((value ?? '').replaceAll(',', '.'));
                            return (amount == null || amount <= 0) ? 'Valor inválido' : null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    final amount = double.parse(amountController.text.replaceAll(',', '.'));
    final cents = (amount * 100).round() * (isEntrada ? 1 : -1);
    final now = DateTime.now();
    try {
      await ref.read(lancamentosControllerProvider.notifier).createTransaction(
            Transaction(
              id: const Uuid().v4(),
              accountId: accountId,
              description: descriptionController.text,
              amountCents: cents,
              date: date,
              status: TransactionStatus.previsto,
              createdAt: now,
              updatedAt: now,
            ),
          );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }
}

/// Quanto do saldo de hoje já está "gasto" por fatura de cartão em
/// aberto — só aparece quando há algo comprometido (Backlog "análise de
/// risco" parte 2, docs/ROADMAP.md; motivação original do usuário: não
/// ficar "refém do cartão"). Só faz sentido no mês corrente — é um
/// retrato de agora, não de um mês navegado (M7, #026).
class _CommittedCardBanner extends ConsumerWidget {
  const _CommittedCardBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final committedCents = ref.watch(committedCardBalanceProvider).valueOrNull ?? 0;
    if (committedCents == 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final color = AppColors.debit(theme.brightness);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card_outlined, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Comprometido com fatura em aberto',
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
          Text(
            formatCents(committedCents),
            style: AppTheme.money(theme.textTheme.bodyMedium).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// Seletor de mês/ano (M7, #026) — troca os dois parâmetros de
/// `monthlyProjectionProvider`, a engine já aceita qualquer horizonte.
class _MonthSelector extends StatelessWidget {
  const _MonthSelector({required this.month, required this.onChanged});

  final DateOnly month;
  final ValueChanged<DateOnly> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onChanged(month.addMonths(-1)),
        ),
        Text(
          _formatMonthYear(month),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => onChanged(month.addMonths(1)),
        ),
      ],
    );
  }

  String _formatMonthYear(DateOnly month) {
    final formatted = DateFormat('MMM/yy', 'pt_BR').format(month.toDateTime());
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: AppColors.textMuted(theme.brightness),
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('DIA', style: style)),
          Expanded(child: Text('DIFERENÇA', style: style)),
          Text('SALDO', style: style),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.balance, required this.scaleCents, super.key});

  final DailyBalance balance;
  final int scaleCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = balance.date == DateOnly.fromDateTime(DateTime.now());
    final diffCents = balance.projectedCreditsCents - balance.projectedDebitsCents;
    final diffColor = diffCents == 0
        ? AppColors.textMuted(theme.brightness)
        : (diffCents > 0 ? AppColors.credit(theme.brightness) : AppColors.debit(theme.brightness));
    final saldoColor = _balanceColor(balance.closingBalanceCents, scaleCents, theme.brightness);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DayDetailScreen(date: balance.date)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      balance.date.day.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _formatWeekday(balance.date),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                    ),
                    if (isToday) const _TodayChip(),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  diffCents == 0 ? '—' : formatCents(diffCents),
                  style: theme.textTheme.bodyMedium?.copyWith(color: diffColor),
                ),
              ),
              Text(
                formatCents(balance.closingBalanceCents),
                style: AppTheme.money(theme.textTheme.bodyLarge).copyWith(color: saldoColor),
              ),
              Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted(theme.brightness)),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWeekday(DateOnly date) => DateFormat('EEE', 'pt_BR').format(date.toDateTime());
}

/// Verde escuro (saldo relativamente alto) a vermelho escuro (saldo
/// relativamente baixo/negativo) — pedido do usuário, inspirado na
/// planilha do Breno. `scaleCents` é o maior |saldo| do mês em exibição,
/// então a cor é relativa ao próprio mês, não um limiar fixo.
Color _balanceColor(int cents, int scaleCents, Brightness brightness) {
  if (scaleCents == 0) return AppColors.textMuted(brightness);
  final t = ((cents / scaleCents).clamp(-1.0, 1.0) + 1) / 2;
  return Color.lerp(AppColors.debit(brightness), AppColors.credit(brightness), t)!;
}

String _formatDate(DateOnly date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

class _TodayChip extends StatelessWidget {
  const _TodayChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.amber,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'HOJE',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.onAmber,
              fontWeight: FontWeight.w700,
              fontSize: 9,
            ),
      ),
    );
  }
}
