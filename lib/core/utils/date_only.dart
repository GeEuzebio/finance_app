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
