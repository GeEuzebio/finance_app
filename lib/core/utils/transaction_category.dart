import 'package:flutter/material.dart';

/// Categoria por propósito do gasto — não por meio de pagamento (cartão
/// não é categoria, é só como a compra foi paga). M7, #029: usada em
/// `Transaction`, `RecurrenceRule` e `InvoiceItem` pra responder "pra
/// onde vai meu dinheiro", aditiva à previsibilidade (`PRODUCT.md`), não
/// substitui ela.
enum TransactionCategory { moradia, alimentacao, transporte, lazer, saude, outros }

String categoryLabel(TransactionCategory category) => switch (category) {
      TransactionCategory.moradia => 'Moradia',
      TransactionCategory.alimentacao => 'Alimentação',
      TransactionCategory.transporte => 'Transporte',
      TransactionCategory.lazer => 'Lazer',
      TransactionCategory.saude => 'Saúde',
      TransactionCategory.outros => 'Outros',
    };

IconData categoryIcon(TransactionCategory category) => switch (category) {
      TransactionCategory.moradia => Icons.home_outlined,
      TransactionCategory.alimentacao => Icons.restaurant_outlined,
      TransactionCategory.transporte => Icons.directions_car_outlined,
      TransactionCategory.lazer => Icons.sports_esports_outlined,
      TransactionCategory.saude => Icons.favorite_outline,
      TransactionCategory.outros => Icons.category_outlined,
    };
