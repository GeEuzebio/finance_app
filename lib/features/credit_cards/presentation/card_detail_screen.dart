import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../domain/entities/invoice.dart';
import '../domain/entities/invoice_item.dart';
import 'credit_cards_providers.dart';

class CardDetailScreen extends ConsumerWidget {
  const CardDetailScreen({required this.cardId, super.key});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(cardDetailControllerProvider(cardId));

    return Scaffold(
      appBar: AppBar(title: Text(detailAsync.valueOrNull?.card.name ?? 'Cartão')),
      body: detailAsync.when(
        data: (detail) => _CardDetailBody(cardId: cardId, detail: detail),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: '$error'),
      ),
      floatingActionButton: detailAsync.hasValue
          ? FloatingActionButton(
              onPressed: () => _showRegisterPurchaseDialog(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _showRegisterPurchaseDialog(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    final installmentsController = TextEditingController(text: '1');
    var purchaseDate = DateOnly.fromDateTime(DateTime.now());

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Nova compra'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Valor total (R\$)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      double.tryParse((value ?? '').replaceAll(',', '.')) == null
                          ? 'Valor inválido'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: installmentsController,
                  decoration: const InputDecoration(labelText: 'Parcelas'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final n = int.tryParse(value ?? '');
                    return (n == null || n < 1) ? 'Mínimo 1' : null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Data: ${purchaseDate.day.toString().padLeft(2, '0')}/'
                        '${purchaseDate.month.toString().padLeft(2, '0')}/'
                        '${purchaseDate.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: dialogContext,
                          initialDate: purchaseDate.toDateTime(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => purchaseDate = DateOnly.fromDateTime(picked));
                        }
                      },
                      child: const Text('Alterar'),
                    ),
                  ],
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

                final cents =
                    -(double.parse(amountController.text.replaceAll(',', '.')) * 100)
                        .round()
                        .abs();
                await ref.read(cardDetailControllerProvider(cardId).notifier).registerPurchase(
                      description: descriptionController.text,
                      amountCents: cents,
                      purchaseDate: purchaseDate,
                      installments: int.parse(installmentsController.text),
                    );
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardDetailBody extends ConsumerWidget {
  const _CardDetailBody({required this.cardId, required this.detail});

  final String cardId;
  final CardDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final items = detail.items;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _InvoiceSummaryCard(cardId: cardId, detail: detail),
        const SizedBox(height: 20),
        Text(
          'Itens da fatura',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Text(
            'Nenhuma compra lançada nessa fatura ainda.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textMuted(theme.brightness)),
          )
        else
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _InvoiceItemTile(cardId: cardId, item: item),
              )),
      ],
    );
  }
}

class _InvoiceSummaryCard extends ConsumerWidget {
  const _InvoiceSummaryCard({required this.cardId, required this.detail});

  final String cardId;
  final CardDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final invoice = detail.invoice;
    final isNegative = detail.totalCents < 0;
    final moneyColor =
        isNegative ? AppColors.debit(theme.brightness) : theme.colorScheme.onSurface;

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
                  'Fatura ${invoice.referenceMonth}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                _StatusChip(status: invoice.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Fecha em ${_formatDate(invoice.closingDate)} · Vence em ${_formatDate(invoice.dueDate)}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textMuted(theme.brightness)),
            ),
            const SizedBox(height: 16),
            Text(
              formatCents(detail.totalCents),
              style: AppTheme.money(theme.textTheme.headlineSmall).copyWith(color: moneyColor),
            ),
            if (invoice.status != InvoiceStatus.paga) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    try {
                      await ref
                          .read(cardDetailControllerProvider(cardId).notifier)
                          .payInvoice();
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('$error')));
                      }
                    }
                  },
                  child: const Text('Pagar fatura'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _statusLabel(status),
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.textMuted(theme.brightness),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InvoiceItemTile extends ConsumerWidget {
  const _InvoiceItemTile({required this.cardId, required this.item});

  final String cardId;
  final InvoiceItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    style: theme.textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.installmentTotal > 1) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Parcela ${item.installmentNumber}/${item.installmentTotal}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              formatCents(item.amountCents),
              style: AppTheme.money(theme.textTheme.bodyLarge).copyWith(color: moneyColor),
            ),
            IconButton(
              tooltip: 'Estornar',
              icon: const Icon(Icons.undo, size: 20),
              onPressed: () async {
                try {
                  await ref.read(cardDetailControllerProvider(cardId).notifier).reverseItem(item);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('$error')));
                  }
                }
              },
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
              'Não deu pra carregar essa fatura',
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

String _statusLabel(InvoiceStatus status) => switch (status) {
      InvoiceStatus.aberta => 'Aberta',
      InvoiceStatus.fechada => 'Fechada',
      InvoiceStatus.paga => 'Paga',
    };

String _formatDate(DateOnly date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
