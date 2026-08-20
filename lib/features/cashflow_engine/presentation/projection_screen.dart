import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../../../core/utils/transaction_category.dart';
import '../../../core/widgets/state_views.dart';
import '../../accounts/domain/entities/account.dart';
import '../../accounts/presentation/accounts_providers.dart';
import '../../transactions/domain/entities/check_in_item.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../../transactions/presentation/lancamentos_providers.dart';
import '../domain/entities/daily_balance.dart';
import 'projection_providers.dart';

class ProjectionScreen extends ConsumerStatefulWidget {
  const ProjectionScreen({super.key});

  @override
  ConsumerState<ProjectionScreen> createState() => _ProjectionScreenState();
}

class _ProjectionScreenState extends ConsumerState<ProjectionScreen> {
  var _month = DateOnly.fromDateTime(DateTime.now());
  late var _selectedDate = DateOnly.fromDateTime(DateTime.now());

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
            onChanged: (m) => setState(() {
              _month = m;
              _selectedDate = DateOnly(m.year, m.month, 1);
            }),
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
                    message: 'Não deu pra calcular sua previsão pra este mês.',
                  );
                }
                final scaleCents = consolidated
                    .map((b) => b.closingBalanceCents.abs())
                    .fold(0, (max, v) => v > max ? v : max);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    _MonthCalendar(
                      days: consolidated,
                      scaleCents: scaleCents,
                      selectedDate: _selectedDate,
                      onSelect: (d) => setState(() => _selectedDate = d),
                    ),
                    const SizedBox(height: 24),
                    _DayMovementPanel(date: _selectedDate),
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
    if (accounts.isEmpty) return;

    final accountId = accounts.first.id;
    var isEntrada = false;
    var category = TransactionCategory.outros;
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text('Novo movimento — ${_formatFullDate(_selectedDate)}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(height: 12),
                DropdownButtonFormField<TransactionCategory>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: TransactionCategory.values
                      .map((c) => DropdownMenuItem(value: c, child: Text(categoryLabel(c))))
                      .toList(),
                  onChanged: (value) => setDialogState(() => category = value ?? category),
                ),
              ],
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
              date: _selectedDate,
              status: TransactionStatus.previsto,
              category: category,
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

const _weekdayLabels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

/// Grade de calendário do mês (M7, #028 — substitui a lista de linhas do
/// #020/#026). Cada célula tinge o fundo com o mesmo gradiente
/// verde→vermelho que a coluna Saldo já usava (`_balanceColor`, função
/// inalterada) — padrão de calendário financeiro com célula colorida em
/// vez de valor cravado (referência: Toshl/Zaim), o valor de verdade
/// aparece no painel abaixo ao selecionar o dia (referência: Organizze,
/// toca no dia → lança/vê movimento).
class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.days,
    required this.scaleCents,
    required this.selectedDate,
    required this.onSelect,
  });

  final List<DailyBalance> days;
  final int scaleCents;
  final DateOnly selectedDate;
  final ValueChanged<DateOnly> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateOnly.fromDateTime(DateTime.now());
    final firstWeekday = days.first.date.toDateTime().weekday % 7; // 0=dom..6=sáb
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: AppColors.textMuted(theme.brightness),
      fontWeight: FontWeight.w600,
    );

    return Column(
      children: [
        Row(
          children: _weekdayLabels
              .map((l) => Expanded(child: Center(child: Text(l, style: labelStyle))))
              .toList(),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: firstWeekday + days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox.shrink();
            final day = days[index - firstWeekday];
            return _CalendarCell(
              day: day,
              scaleCents: scaleCents,
              isToday: day.date == today,
              isSelected: day.date == selectedDate,
              onTap: () => onSelect(day.date),
            );
          },
        ),
      ],
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.day,
    required this.scaleCents,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final DailyBalance day;
  final int scaleCents;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final balanceColor = _balanceColor(day.closingBalanceCents, scaleCents, theme.brightness);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.amber : balanceColor.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(10),
            border: isToday && !isSelected
                ? Border.all(color: AppColors.amber, width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            day.date.day.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.onAmber : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
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

/// Painel de movimentação do dia selecionado — embaixo do calendário, na
/// mesma tela (M7, #028; antes era a tela própria `DayDetailScreen`,
/// #026, aberta por navegação — o pedido agora é ver tudo junto, sem
/// trocar de tela).
class _DayMovementPanel extends ConsumerWidget {
  const _DayMovementPanel({required this.date});

  final DateOnly date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final itemsAsync = ref.watch(dayLedgerProvider(day: date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatFullDate(date),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Não há entradas nem saídas previstas pra este dia.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                ),
              );
            }
            final totalCents = items.fold(0, (sum, item) => sum + item.amountCents);
            return Column(
              children: [
                _TotalBanner(totalCents: totalCents),
                const SizedBox(height: 12),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LedgerCard(item: item),
                    )),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => ErrorStateView(
            title: 'Não deu pra carregar este dia',
            message: '$error',
          ),
        ),
      ],
    );
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
            Icon(
              isNegative ? Icons.arrow_downward : Icons.arrow_upward,
              size: 18,
              color: moneyColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(categoryIcon(item.category),
                          size: 14, color: AppColors.textMuted(theme.brightness)),
                      const SizedBox(width: 4),
                      Text(
                        categoryLabel(item.category),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                      ),
                    ],
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

String _formatFullDate(DateOnly date) {
  final formatted = DateFormat('EEEE, d \'de\' MMMM', 'pt_BR').format(date.toDateTime());
  return formatted[0].toUpperCase() + formatted.substring(1);
}
