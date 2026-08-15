import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/money.dart';
import '../../accounts/domain/entities/account.dart';
import '../../accounts/presentation/accounts_providers.dart';
import '../../credit_cards/domain/entities/credit_card.dart';
import '../../credit_cards/presentation/credit_cards_providers.dart';
import '../domain/csv_parser.dart';
import '../domain/entities/parsed_transaction.dart';
import '../domain/ofx_parser.dart';
import '../domain/usecases/import_transactions.dart';
import 'import_providers.dart';

enum _ImportTarget { extrato, fatura }

class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  var _target = _ImportTarget.extrato;
  String? _creditCardId;
  String? _fileName;
  List<ParsedTransaction>? _parsed;
  var _isBusy = false;

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsControllerProvider).valueOrNull ?? const <Account>[];
    final cards = ref.watch(creditCardsControllerProvider).valueOrNull ?? const <CreditCard>[];
    final theme = Theme.of(context);
    final destinations = _target == _ImportTarget.extrato ? accounts.length : cards.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar')),
      body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SegmentedButton<_ImportTarget>(
                  segments: const [
                    ButtonSegment(value: _ImportTarget.extrato, label: Text('Extrato')),
                    ButtonSegment(value: _ImportTarget.fatura, label: Text('Fatura')),
                  ],
                  selected: {_target},
                  onSelectionChanged: (selection) => setState(() {
                    _target = selection.first;
                    _fileName = null;
                    _parsed = null;
                  }),
                ),
                const SizedBox(height: 20),
                Text(
                  _target == _ImportTarget.extrato
                      ? 'Arquivo OFX ou CSV exportado do internet banking. Só lançamentos com '
                          'identificador novo são importados — reimportar o mesmo período não '
                          'duplica nada.'
                      : 'Arquivo OFX ou CSV exportado da fatura do cartão. Cada linha vira um '
                          'item na fatura do ciclo certo; reimportar o mesmo período não duplica '
                          'nada.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                ),
                const SizedBox(height: 20),
                if (_target == _ImportTarget.fatura)
                  if (cards.isEmpty)
                    Text(
                      'Crie um cartão antes de importar uma fatura.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                    )
                  else
                    DropdownButtonFormField<String>(
                      initialValue: _creditCardId ?? cards.first.id,
                      decoration: const InputDecoration(labelText: 'Cartão de destino'),
                      items: cards
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                          .toList(),
                      onChanged: (value) => setState(() => _creditCardId = value),
                    ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(_fileName ?? 'Selecionar arquivo (OFX/CSV)'),
                  onPressed: _isBusy || destinations == 0 ? null : _pickFile,
                ),
                if (_parsed != null) ...[
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_parsed!.length} lançamento(s) encontrado(s)',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          ..._parsed!.take(5).map(
                                (t) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.description,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                      Text(
                                        formatCents(t.amountCents),
                                        style: AppTheme.money(theme.textTheme.bodySmall),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          if (_parsed!.length > 5)
                            Text(
                              'e mais ${_parsed!.length - 5}...',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textMuted(theme.brightness)),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _isBusy ? null : _confirmImport,
                    child: Text(_isBusy ? 'Importando...' : 'Importar'),
                  ),
                ],
              ],
            ),
    );
  }

  Future<void> _pickFile() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['ofx', 'csv'],
    );
    if (file == null) return;

    setState(() {
      _isBusy = true;
      _fileName = file.name;
      _parsed = null;
    });

    try {
      final bytes = await file.readAsBytes();
      final content = utf8.decode(bytes, allowMalformed: true);
      final isOfx = file.name.toLowerCase().endsWith('.ofx');
      final parsed = isOfx ? parseOfx(content) : parseCsv(content);
      setState(() => _parsed = parsed);
    } on FormatException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _confirmImport() async {
    final parsed = _parsed;
    if (parsed == null) return;

    setState(() => _isBusy = true);
    try {
      final notifier = ref.read(importControllerProvider.notifier);
      final ImportResult result;
      if (_target == _ImportTarget.extrato) {
        final accounts = ref.read(accountsControllerProvider).valueOrNull ?? const <Account>[];
        result = await notifier.import(accountId: accounts.first.id, parsed: parsed);
      } else {
        final cards = ref.read(creditCardsControllerProvider).valueOrNull ?? const <CreditCard>[];
        final creditCardId = _creditCardId ?? cards.first.id;
        result = await notifier.importInvoice(creditCardId: creditCardId, parsed: parsed);
      }
      if (mounted) {
        setState(() {
          _parsed = null;
          _fileName = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result.imported} importado(s), ${result.skipped} já existente(s).',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }
}
