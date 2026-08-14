/// Data sem hora, fuso America/Sao_Paulo (docs/ARCHITECTURE.md §4).
/// Sempre truncada à meia-noite na construção — nunca carrega componente
/// de hora, então duas instâncias do mesmo dia são sempre iguais.
class DateOnly implements Comparable<DateOnly> {
  DateOnly(int year, int month, int day) : _value = DateTime(year, month, day);

  DateOnly.fromDateTime(DateTime dateTime)
      : _value = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final DateTime _value;

  int get year => _value.year;
  int get month => _value.month;
  int get day => _value.day;

  DateTime toDateTime() => _value;

  DateOnly addDays(int days) =>
      DateOnly.fromDateTime(_value.add(Duration(days: days)));

  /// Avança [months] meses, com o mesmo clamp de dia inválido de
  /// [clampedMonthDate] (ex.: dia 31 + 1 mês em abril -> 30/04, não maio).
  DateOnly addMonths(int months) {
    final monthsFromEpoch = month - 1 + months;
    return clampedMonthDate(
      year + monthsFromEpoch ~/ 12,
      monthsFromEpoch % 12 + 1,
      day,
    );
  }

  bool isBefore(DateOnly other) => _value.isBefore(other._value);
  bool isAfter(DateOnly other) => _value.isAfter(other._value);

  bool operator <(DateOnly other) => isBefore(other);
  bool operator <=(DateOnly other) => !isAfter(other);
  bool operator >(DateOnly other) => isAfter(other);
  bool operator >=(DateOnly other) => !isBefore(other);

  @override
  int compareTo(DateOnly other) => _value.compareTo(other._value);

  @override
  bool operator ==(Object other) => other is DateOnly && other._value == _value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => _value.toIso8601String().split('T').first;
}

/// Gera a data pedida; se o dia não existir naquele mês (ex.: dia 31 em
/// fevereiro), usa o último dia real do mês (docs/CASHFLOW_ENGINE.md §3 —
/// regra de dia inválido). Compartilhado entre a expansão de recorrência e
/// o cálculo de datas de fatura de cartão.
DateOnly clampedMonthDate(int year, int month, int day) {
  final lastDayOfMonth = DateTime(year, month + 1, 0).day;
  return DateOnly(year, month, day > lastDayOfMonth ? lastDayOfMonth : day);
}
