import '../../../core/utils/date_only.dart';
import 'entities/parsed_transaction.dart';

/// Extrai lançamentos de um extrato OFX (M7, #023). OFX é SGML, não XML —
/// tags de folha não têm fechamento (`<TRNAMT>-150.00` sem
/// `</TRNAMT>`), por isso o parser é baseado em regex por campo dentro de
/// cada bloco `<STMTTRN>...</STMTTRN>`, em vez de um parser XML de
/// verdade (que rejeitaria o arquivo).
List<ParsedTransaction> parseOfx(String content) {
  final blocks = RegExp(
    r'<STMTTRN>(.*?)</STMTTRN>',
    dotAll: true,
    caseSensitive: false,
  ).allMatches(content);

  final transactions = <ParsedTransaction>[];
  for (final block in blocks) {
    final body = block.group(1)!;
    final dtPosted = _field(body, 'DTPOSTED');
    final trnAmt = _field(body, 'TRNAMT');
    if (dtPosted == null || trnAmt == null) continue;

    final memo = _field(body, 'MEMO');
    final name = _field(body, 'NAME');
    final fitId = _field(body, 'FITID');
    final description = memo ?? name ?? 'Importado';

    transactions.add(ParsedTransaction(
      date: _parseOfxDate(dtPosted),
      description: description,
      amountCents: (double.parse(trnAmt) * 100).round(),
      externalId: 'ofx:${fitId ?? '$dtPosted|$trnAmt|$description'}',
    ));
  }
  return transactions;
}

String? _field(String block, String tag) {
  final match = RegExp('<$tag>([^\r\n<]+)', caseSensitive: false).firstMatch(block);
  return match?.group(1)?.trim();
}

DateOnly _parseOfxDate(String dtPosted) {
  final digits = dtPosted.substring(0, 8);
  return DateOnly(
    int.parse(digits.substring(0, 4)),
    int.parse(digits.substring(4, 6)),
    int.parse(digits.substring(6, 8)),
  );
}
