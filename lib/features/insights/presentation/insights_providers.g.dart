// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generateFinancialInsightsUseCaseHash() =>
    r'8c1572df804c32da8c08acb1d2e850936c295192';

/// See also [generateFinancialInsightsUseCase].
@ProviderFor(generateFinancialInsightsUseCase)
final generateFinancialInsightsUseCaseProvider =
    AutoDisposeProvider<GenerateFinancialInsights>.internal(
  generateFinancialInsightsUseCase,
  name: r'generateFinancialInsightsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generateFinancialInsightsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GenerateFinancialInsightsUseCaseRef
    = AutoDisposeProviderRef<GenerateFinancialInsights>;
String _$insightsControllerHash() =>
    r'3e430ea548ec3c655e344bcc90bc4badbff155af';

/// See also [InsightsController].
@ProviderFor(InsightsController)
final insightsControllerProvider = AutoDisposeNotifierProvider<
    InsightsController, FinancialInsights?>.internal(
  InsightsController.new,
  name: r'insightsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$insightsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InsightsController = AutoDisposeNotifier<FinancialInsights?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
