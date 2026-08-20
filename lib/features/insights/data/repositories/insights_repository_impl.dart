import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/guard_database.dart';
import '../../../../core/utils/transaction_category.dart';
import '../../domain/entities/financial_insights.dart';
import '../../domain/repositories/insights_repository.dart';

const _function = 'financial-insights';

@LazySingleton(as: InsightsRepository)
class InsightsRepositoryImpl implements InsightsRepository {
  InsightsRepositoryImpl(this._client);
  final SupabaseClient _client;

  @override
  Future<Either<Failure, FinancialInsights>> generate(InsightsRequestData data) {
    return guardDatabase(() async {
      final response = await _client.functions.invoke(
        _function,
        body: {
          'categoryCents': {
            for (final entry in data.categoryCents.entries)
              categoryLabel(entry.key): entry.value,
          },
          'necessidadesCents': data.necessidadesCents,
          'desejosCents': data.desejosCents,
          'reservaCents': data.reservaCents,
          'savedCents': data.savedCents,
          'savingsPercent': data.savingsPercent,
          'overdueCents': data.overdueCents,
        },
      );
      final suggestions = (response.data['suggestions'] as List).cast<String>();
      return FinancialInsights(suggestions: suggestions, generatedAt: DateTime.now());
    });
  }
}
