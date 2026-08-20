import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/transaction_category.dart';
import '../entities/financial_insights.dart';

typedef InsightsRequestData = ({
  Map<TransactionCategory, int> categoryCents,
  int necessidadesCents,
  int desejosCents,
  int reservaCents,
  int savedCents,
  double savingsPercent,
  int overdueCents,
});

abstract class InsightsRepository {
  Future<Either<Failure, FinancialInsights>> generate(InsightsRequestData data);
}
