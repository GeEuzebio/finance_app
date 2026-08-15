import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/state_views.dart';
import '../../accounts/domain/entities/account.dart';
import '../../accounts/presentation/accounts_providers.dart';
import '../domain/entities/recurrence_rule.dart';
import '../domain/entities/transaction.dart';
import 'lancamentos_providers.dart';

enum _Tipo { avulso, fixa, variavel }

class LancamentosScreen extends ConsumerWidget {
  const LancamentosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(lancamentosControllerProvider);
    final accounts = ref.watch(accountsControllerProvider).valueOrNull ?? const <Account>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Lançamentos')),
      body: dataAsync.when(
        data: (data) {
          if (data.avulsos.isEmpty && data.fixas.isEmpty && data.variaveis.isEmpty) {
            return const EmptyStateView(
              icon: Icons.receipt_long_outlined,
              title: 'Nenhum lançamento ainda',
              message: 'Cadastre uma entrada, saída ou conta recorrente pra começar.',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              if (data.fixas.isNotEmpty) ...[
                const _SectionHeader('Contas fixas'),
                ...data.fixas.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RecurrenceCard(rule: r),
                    )),
              ],
              if (data.variaveis.isNotEmpty) ...[
                const _SectionHeader('Contas variáveis'),
                ...data.variaveis.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RecurrenceCard(rule: r),
                    )),
              ],
              if (data.avulsos.isNotEmpty) ...[
                const _SectionHeader('Avulsos'),
                ...data.avulsos.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _TransactionCard(transaction: t),
                    )),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateView(
          title: 'Não deu pra carregar seus lançamentos',
          message: '$error',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref, accounts),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context, WidgetRef ref, List<Account> accounts) async {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final intervalController = TextEditingController(text: '1');
    var tipo = _Tipo.avulso;
    final accountId = accounts.first.id;
    var isEntrada = false;
    var date = DateOnly.fromDateTime(DateTime.now());
    var endDate = DateOnly.fromDateTime(DateTime.now());
    var hasEndDate = false;
    var frequency = RecurrenceFrequency.monthly;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Novo lançamento'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedButton<_Tipo>(
                    segments: const [
                      ButtonSegment(value: _Tipo.avulso, label: Text('Avulso')),
                      ButtonSegment(value: _Tipo.fixa, label: Text('Fixa')),
                      ButtonSegment(value: _Tipo.variavel, label: Text('Variável')),
                    ],
                    selected: {tipo},
                    onSelectionChanged: (s) => setState(() => tipo = s.first),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
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
                          onChanged: (value) => setState(() => isEntrada = value ?? isEntrada),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          decoration: const InputDecoration(labelText: 'Valor (R\$)'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) =>
                              double.tryParse((value ?? '').replaceAll(',', '.')) == null
                                  ? 'Valor inválido'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tipo == _Tipo.avulso
                              ? 'Data: ${_formatDate(date)}'
                              : 'Início: ${_formatDate(date)}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: dialogContext,
                            initialDate: date.toDateTime(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          );
                          if (picked != null) {
                            setState(() => date = DateOnly.fromDateTime(picked));
                          }
                        },
                        child: const Text('Alterar'),
                      ),
                    ],
                  ),
                  if (tipo != _Tipo.avulso) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<RecurrenceFrequency>(
                            initialValue: frequency,
                            decoration: const InputDecoration(labelText: 'Frequência'),
                            items: RecurrenceFrequency.values
                                .map((f) => DropdownMenuItem(value: f, child: Text(_frequencyLabel(f))))
                                .toList(),
                            onChanged: (value) => setState(() => frequency = value ?? frequency),
                          ),
                        ),
                        if (frequency != RecurrenceFrequency.weekly) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: intervalController,
                              decoration: InputDecoration(labelText: _intervalLabel(frequency)),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final n = int.tryParse(value ?? '');
                                return (n == null || n < 1) ? 'Mínimo 1' : null;
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: hasEndDate,
                          onChanged: (value) => setState(() => hasEndDate = value ?? false),
                        ),
                        const Text('Tem data de fim'),
                        if (hasEndDate) ...[
                          const Spacer(),
                          Text(_formatDate(endDate)),
                          TextButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: dialogContext,
                                initialDate: endDate.toDateTime(),
                                firstDate: date.toDateTime(),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                              );
                              if (picked != null) {
                                setState(() => endDate = DateOnly.fromDateTime(picked));
                              }
                            },
                            child: const Text('Alterar'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
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

                final signal = isEntrada ? 1 : -1;
                final cents =
                    (double.parse(amountController.text.replaceAll(',', '.')) * 100)
                            .round()
                            .abs() *
                        signal;

                try {
                  if (tipo == _Tipo.avulso) {
                    final now = DateTime.now();
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
                  } else {
                    await ref.read(lancamentosControllerProvider.notifier).createRecurrenceRule(
                          RecurrenceRule(
                            id: const Uuid().v4(),
                            accountId: accountId,
                            description: descriptionController.text,
                            amountCents: cents,
                            frequency: frequency,
                            interval: frequency == RecurrenceFrequency.weekly
                                ? 1
                                : int.parse(intervalController.text),
                            startDate: date,
                            endDate: hasEndDate ? endDate : null,
                            isVariable: tipo == _Tipo.variavel,
                            createdAt: DateTime.now(),
                          ),
                        );
                  }
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                } catch (error) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext)
                        .showSnackBar(SnackBar(content: Text('$error')));
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

String _frequencyLabel(RecurrenceFrequency frequency) => switch (frequency) {
      RecurrenceFrequency.weekly => 'Semanal',
      RecurrenceFrequency.monthly => 'Mensal',
      RecurrenceFrequency.yearly => 'Anual',
      RecurrenceFrequency.custom => 'Personalizado (dias)',
    };

String _intervalLabel(RecurrenceFrequency frequency) => switch (frequency) {
      RecurrenceFrequency.monthly => 'A cada N meses',
      RecurrenceFrequency.yearly => 'A cada N anos',
      RecurrenceFrequency.custom => 'A cada N dias',
      RecurrenceFrequency.weekly => 'Intervalo',
    };

String _formatDate(DateOnly date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = transaction.amountCents < 0;
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
                  Text(transaction.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(transaction.date),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                  ),
                ],
              ),
            ),
            Text(
              formatCents(transaction.amountCents),
              style: AppTheme.money(theme.textTheme.bodyLarge).copyWith(color: moneyColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecurrenceCard extends StatelessWidget {
  const _RecurrenceCard({required this.rule});

  final RecurrenceRule rule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = rule.amountCents < 0;
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
                  Text(rule.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    _frequencyLabel(rule.frequency),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                  ),
                ],
              ),
            ),
            Text(
              formatCents(rule.amountCents),
              style: AppTheme.money(theme.textTheme.bodyLarge).copyWith(color: moneyColor),
            ),
          ],
        ),
      ),
    );
  }
}
