import '../../../core/utils/date_only.dart';
import 'entities/parsed_transaction.dart';

/// Extrai lançamentos de um CSV de extrato (M7, #023). Não existe um
/// padrão único de CSV bancário no Brasil (ao contrário do OFX) — este
/// parser assume um cabeçalho com colunas reconhecíveis (Data/Descrição/
/// Valor, em qualquer ordem, vírgula ou ponto-e-vírgula como separador) e
/// lança `FormatException` com uma mensagem legível se não encontrar
/// alguma delas, em vez de importar dado errado silenciosamente.
List<ParsedTransaction> parseCsv(String content) {
  final lines = content
      .split(RegExp(r'\r\n|\r|\n'))
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
  if (lines.isEmpty) return const [];

  final delimiter = lines.first.contains(';') ? ';' : ',';
  final header = _splitCsvLine(lines.first, delimiter).map((h) => _normalize(h)).toList();

  final dateIndex = _indexOfAny(header, ['data', 'date']);
  final descriptionIndex =
      _indexOfAny(header, ['descricao', 'historico', 'description', 'memo']);
  final amountIndex = _indexOfAny(header, ['valor', 'amount']);

  if (dateIndex == null || descriptionIndex == null || amountIndex == null) {
    throw const FormatException(
      'CSV precisa de colunas de data, descrição e valor no cabeçalho.',
    );
  }

  final transactions = <ParsedTransaction>[];
  for (final line in lines.skip(1)) {
    final fields = _splitCsvLine(line, delimiter);
    if (fields.length <= [dateIndex, descriptionIndex, amountIndex].reduce((a, b) => a > b ? a : b)) {
      continue;
    }
    final date = _parseDate(fields[dateIndex].trim());
    final description = fields[descriptionIndex].trim();
    final amountCents = _parseAmountCents(fields[amountIndex].trim());
    if (date == null) continue;

    transactions.add(ParsedTransaction(
      date: date,
      description: description.isEmpty ? 'Importado' : description,
      amountCents: amountCents,
      externalId: 'csv:$date|$description|$amountCents',
    ));
  }
  return transactions;
}

String _normalize(String value) =>
    value.trim().toLowerCase().replaceAll(RegExp('[áàâã]'), 'a').replaceAll('é', 'e').replaceAll(
          'í',
          'i',
        ).replaceAll(RegExp('[óô]'), 'o').replaceAll('ç', 'c');

int? _indexOfAny(List<String> header, List<String> candidates) {
  for (final candidate in candidates) {
    final index = header.indexWhere((h) => h.contains(candidate));
    if (index != -1) return index;
  }
  return null;
}

List<String> _splitCsvLine(String line, String delimiter) {
  final fields = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      inQuotes = !inQuotes;
    } else if (char == delimiter && !inQuotes) {
      fields.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }
  fields.add(buffer.toString());
  return fields;
}

DateOnly? _parseDate(String raw) {
  final brMatch = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{2,4})$').firstMatch(raw);
  if (brMatch != null) {
    final year = int.parse(brMatch.group(3)!);
    return DateOnly(
      year < 100 ? 2000 + year : year,
      int.parse(brMatch.group(2)!),
      int.parse(brMatch.group(1)!),
    );
  }
  final isoMatch = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(raw);
  if (isoMatch != null) {
    return DateOnly(
      int.parse(isoMatch.group(1)!),
      int.parse(isoMatch.group(2)!),
      int.parse(isoMatch.group(3)!),
    );
  }
  return null;
}

int _parseAmountCents(String raw) {
  var normalized = raw.replaceAll(RegExp(r'[^\d,.\-]'), '');
  if (normalized.contains(',') && normalized.contains('.')) {
    normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
  } else if (normalized.contains(',')) {
    normalized = normalized.replaceAll(',', '.');
  }
  final value = double.tryParse(normalized) ?? 0;
  return (value * 100).round();
}
