import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/state_views.dart';
import '../../accounts/domain/entities/account.dart';
import '../../accounts/presentation/accounts_providers.dart';
import '../domain/entities/credit_card.dart';
import 'card_detail_screen.dart';
import 'credit_cards_providers.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(creditCardsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cartões')),
      body: cardsAsync.when(
        data: (cards) => cards.isEmpty
            ? const EmptyStateView(
                icon: Icons.credit_card_outlined,
                title: 'Nenhum cartão ainda',
                message: 'Cadastre um cartão pra acompanhar fatura, compras e parcelamentos.',
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _CardTile(card: cards[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorStateView(
          title: 'Não deu pra carregar seus cartões',
          message: '$error',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCardDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateCardDialog(BuildContext context, WidgetRef ref) async {
    final accounts = ref.read(accountsControllerProvider).valueOrNull ?? const <Account>[];
    if (accounts.isEmpty) return;

    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final closingDayController = TextEditingController();
    final dueDayController = TextEditingController();
    final limitController = TextEditingController();
    final paymentAccountId = accounts.first.id;
    var owner = AccountOwner.eu;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Novo cartão'),
          content: SingleChildScrollView(
            child: Form(
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: closingDayController,
                          decoration: const InputDecoration(labelText: 'Dia de fechamento'),
                          keyboardType: TextInputType.number,
                          validator: _dayValidator,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: dueDayController,
                          decoration: const InputDecoration(labelText: 'Dia de vencimento'),
                          keyboardType: TextInputType.number,
                          validator: _dayValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: limitController,
                    decoration: const InputDecoration(labelText: 'Limite (R\$, opcional)'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => value == null || value.isEmpty
                        ? null
                        : (double.tryParse(value.replaceAll(',', '.')) == null
                            ? 'Valor inválido'
                            : null),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<AccountOwner>(
                    initialValue: owner,
                    decoration: const InputDecoration(labelText: 'Dono'),
                    items: AccountOwner.values
                        .map((o) => DropdownMenuItem(value: o, child: Text(_ownerLabel(o))))
                        .toList(),
                    onChanged: (value) => setState(() => owner = value ?? owner),
                  ),
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

                final limitText = limitController.text;
                final card = CreditCard(
                  id: const Uuid().v4(),
                  name: nameController.text,
                  paymentAccountId: paymentAccountId,
                  closingDay: int.parse(closingDayController.text),
                  dueDay: int.parse(dueDayController.text),
                  limitCents: limitText.isEmpty
                      ? null
                      : (double.parse(limitText.replaceAll(',', '.')) * 100).round(),
                  owner: owner,
                  createdAt: DateTime.now(),
                );

                await ref.read(creditCardsControllerProvider.notifier).createCard(card);
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

String? _dayValidator(String? value) {
  final day = int.tryParse(value ?? '');
  if (day == null || day < 1 || day > 31) return 'Dia entre 1 e 31';
  return null;
}

String _ownerLabel(AccountOwner owner) => switch (owner) {
      AccountOwner.eu => 'Eu',
      AccountOwner.conjuge => 'Cônjuge',
      AccountOwner.conjunta => 'Conjunta',
    };

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card});

  final CreditCard card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => CardDetailScreen(cardId: card.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                ),
                child: Icon(
                  Icons.credit_card_outlined,
                  size: 22,
                  color: AppColors.textMuted(theme.brightness),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fecha dia ${card.closingDay} · Vence dia ${card.dueDay}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                    ),
                  ],
                ),
              ),
              if (card.limitCents != null) ...[
                const SizedBox(width: 8),
                Text(
                  formatCents(card.limitCents!),
                  style: AppTheme.money(theme.textTheme.bodyLarge),
                ),
              ],
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: AppColors.textMuted(theme.brightness)),
            ],
          ),
        ),
      ),
    );
  }
}

