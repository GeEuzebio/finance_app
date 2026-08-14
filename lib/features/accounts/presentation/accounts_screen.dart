import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_only.dart';
import '../../../core/utils/money.dart';
import '../domain/entities/account.dart';
import 'accounts_providers.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Contas')),
      body: accountsAsync.when(
        data: (accounts) => accounts.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _AccountCard(account: accounts[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorState(message: '$error'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateAccountDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateAccountDialog(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final balanceController = TextEditingController();
    var type = AccountType.checking;
    var owner = AccountOwner.eu;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Nova conta'),
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
                  controller: balanceController,
                  decoration: const InputDecoration(labelText: 'Saldo inicial (R\$)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      double.tryParse((value ?? '').replaceAll(',', '.')) == null
                          ? 'Valor inválido'
                          : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AccountType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: AccountType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(_typeLabel(t))))
                      .toList(),
                  onChanged: (value) => setState(() => type = value ?? type),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;

                final cents = (double.parse(
                          balanceController.text.replaceAll(',', '.'),
                        ) *
                        100)
                    .round();
                final account = Account(
                  id: const Uuid().v4(),
                  name: nameController.text,
                  type: type,
                  owner: owner,
                  initialBalanceCents: cents,
                  initialBalanceDate: DateOnly.fromDateTime(DateTime.now()),
                  archived: false,
                  createdAt: DateTime.now(),
                );

                await ref.read(accountsControllerProvider.notifier).createAccount(account);
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

String _ownerLabel(AccountOwner owner) => switch (owner) {
      AccountOwner.eu => 'Eu',
      AccountOwner.conjuge => 'Cônjuge',
      AccountOwner.conjunta => 'Conjunta',
    };

String _typeLabel(AccountType type) => switch (type) {
      AccountType.checking => 'Conta corrente',
      AccountType.savings => 'Poupança',
      AccountType.wallet => 'Carteira',
      AccountType.other => 'Outra',
    };

IconData _typeIcon(AccountType type) => switch (type) {
      AccountType.checking => Icons.account_balance_outlined,
      AccountType.savings => Icons.savings_outlined,
      AccountType.wallet => Icons.account_balance_wallet_outlined,
      AccountType.other => Icons.more_horiz,
    };

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNegative = account.initialBalanceCents < 0;
    final moneyColor = isNegative ? AppColors.debit(theme.brightness) : theme.colorScheme.onSurface;

    return Card(
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
                _typeIcon(account.type),
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
                    account.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _OwnerChip(owner: account.owner),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatCents(account.initialBalanceCents),
              style: AppTheme.money(theme.textTheme.bodyLarge).copyWith(color: moneyColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _OwnerChip extends StatelessWidget {
  const _OwnerChip({required this.owner});

  final AccountOwner owner;

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
        _ownerLabel(owner),
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.textMuted(theme.brightness),
          fontWeight: FontWeight.w600,
        ),
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
            Icon(Icons.account_balance_wallet_outlined, size: 48, color: muted),
            const SizedBox(height: 16),
            Text(
              'Nenhuma conta ainda',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione sua primeira conta pra começar a ver a previsão do seu saldo.',
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
              'Não deu pra carregar suas contas',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted(theme.brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
