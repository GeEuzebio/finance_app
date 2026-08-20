import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../entities/financial_insights.dart';
import '../repositories/insights_repository.dart';

@injectable
class GenerateFinancialInsights {
  GenerateFinancialInsights(this._repository);

  final InsightsRepository _repository;

  Future<Either<Failure, FinancialInsights>> call(InsightsRequestData data) {
    return _repository.generate(data);
  }
}
