import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

/// Formata centavos como moeda pt-BR, ex.: 130000 -> "R\$ 1.300,00".
String formatCents(int cents) => _currencyFormat.format(cents / 100);
