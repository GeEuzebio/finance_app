import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_insights.freezed.dart';

@freezed
class FinancialInsights with _$FinancialInsights {
  const factory FinancialInsights({
    required List<String> suggestions,
    required DateTime generatedAt,
  }) = _FinancialInsights;
}
