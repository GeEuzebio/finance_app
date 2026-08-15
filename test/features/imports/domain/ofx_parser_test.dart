import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/imports/domain/ofx_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extrai lançamentos de um extrato OFX simples', () {
    const ofx = '''
OFXHEADER:100
DATA:OFXSGML
VERSION:102

<OFX>
<BANKMSGSRSV1>
<STMTTRNRS>
<STMTRS>
<BANKTRANLIST>
<STMTTRN>
<TRNTYPE>DEBIT
<DTPOSTED>20260810120000[-03:EST]
<TRNAMT>-150.00
<FITID>202608100001
<MEMO>Mercado
</STMTTRN>
<STMTTRN>
<TRNTYPE>CREDIT
<DTPOSTED>20260805090000[-03:EST]
<TRNAMT>3000.00
<FITID>202608050002
<MEMO>Salário
</STMTTRN>
</BANKTRANLIST>
</STMTRS>
</STMTTRNRS>
</BANKMSGSRSV1>
</OFX>
''';

    final result = parseOfx(ofx);

    expect(result, hasLength(2));
    expect(result[0].date, DateOnly(2026, 8, 10));
    expect(result[0].description, 'Mercado');
    expect(result[0].amountCents, -15000);
    expect(result[0].externalId, 'ofx:202608100001');
    expect(result[1].date, DateOnly(2026, 8, 5));
    expect(result[1].amountCents, 300000);
  });

  test('ignora bloco sem DTPOSTED/TRNAMT', () {
    const ofx = '''
<OFX>
<STMTTRN>
<TRNTYPE>DEBIT
<MEMO>Sem valor nem data
</STMTTRN>
</OFX>
''';

    expect(parseOfx(ofx), isEmpty);
  });

  test('usa NAME quando MEMO não existe, e um id sintético quando FITID falta', () {
    const ofx = '''
<OFX>
<STMTTRN>
<DTPOSTED>20260801000000
<TRNAMT>-50.00
<NAME>Farmácia
</STMTTRN>
</OFX>
''';

    final result = parseOfx(ofx);

    expect(result, hasLength(1));
    expect(result.first.description, 'Farmácia');
    expect(result.first.externalId, startsWith('ofx:20260801000000'));
  });
}
