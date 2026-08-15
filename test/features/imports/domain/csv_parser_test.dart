import 'package:finance_app/core/utils/date_only.dart';
import 'package:finance_app/features/imports/domain/csv_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extrai lançamentos de um CSV com ponto e vírgula e decimal com vírgula', () {
    const csv = 'Data;Descrição;Valor\n'
        '10/08/2026;Mercado;-150,00\n'
        '05/08/2026;Salário;3.000,00\n';

    final result = parseCsv(csv);

    expect(result, hasLength(2));
    expect(result[0].date, DateOnly(2026, 8, 10));
    expect(result[0].description, 'Mercado');
    expect(result[0].amountCents, -15000);
    expect(result[1].amountCents, 300000);
  });

  test('extrai lançamentos de um CSV com vírgula e data ISO', () {
    const csv = 'date,description,amount\n'
        '2026-08-10,Mercado,-150.00\n';

    final result = parseCsv(csv);

    expect(result, hasLength(1));
    expect(result.first.date, DateOnly(2026, 8, 10));
    expect(result.first.amountCents, -15000);
  });

  test('gera externalId determinístico — mesma linha produz o mesmo id', () {
    const csv = 'Data;Descrição;Valor\n10/08/2026;Mercado;-150,00\n';

    final first = parseCsv(csv).first;
    final second = parseCsv(csv).first;

    expect(first.externalId, second.externalId);
  });

  test('lança FormatException quando o cabeçalho não tem as colunas esperadas', () {
    const csv = 'Coluna A;Coluna B\nx;y\n';

    expect(() => parseCsv(csv), throwsFormatException);
  });

  test('respeita campos entre aspas contendo o delimitador', () {
    const csv = 'Data;Descrição;Valor\n10/08/2026;"Mercado; Padaria";-150,00\n';

    final result = parseCsv(csv);

    expect(result.first.description, 'Mercado; Padaria');
  });
}
