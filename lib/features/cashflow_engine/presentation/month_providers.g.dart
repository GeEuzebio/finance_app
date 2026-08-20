// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMonthlySummaryUseCaseHash() =>
    r'0bdce2daac4c9a5cda1394d90c3b9f155eb65caf';

/// See also [getMonthlySummaryUseCase].
@ProviderFor(getMonthlySummaryUseCase)
final getMonthlySummaryUseCaseProvider =
    AutoDisposeProvider<GetMonthlySummary>.internal(
  getMonthlySummaryUseCase,
  name: r'getMonthlySummaryUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMonthlySummaryUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetMonthlySummaryUseCaseRef = AutoDisposeProviderRef<GetMonthlySummary>;
String _$getOverdueCardDebtUseCaseHash() =>
    r'a055654f7b3d430bcdc2158ddeea37c8943c20bf';

/// See also [getOverdueCardDebtUseCase].
@ProviderFor(getOverdueCardDebtUseCase)
final getOverdueCardDebtUseCaseProvider =
    AutoDisposeProvider<GetOverdueCardDebt>.internal(
  getOverdueCardDebtUseCase,
  name: r'getOverdueCardDebtUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getOverdueCardDebtUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetOverdueCardDebtUseCaseRef
    = AutoDisposeProviderRef<GetOverdueCardDebt>;
String _$monthlySummaryHash() => r'8d663caef678ec39274ecaf81162902794cb055f';

/// See also [monthlySummary].
@ProviderFor(monthlySummary)
final monthlySummaryProvider =
    AutoDisposeFutureProvider<MonthlySummary>.internal(
  monthlySummary,
  name: r'monthlySummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlySummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlySummaryRef = AutoDisposeFutureProviderRef<MonthlySummary>;
String _$overdueCardDebtHash() => r'f6ff0237878498eff8d89c6ae0505444015c0de5';

/// Dívida de fatura atrasada (M7, #029, plano de quitação) — `<= 0`,
/// mesma convenção de débito de `committedCardBalanceProvider`.
///
/// Copied from [overdueCardDebt].
@ProviderFor(overdueCardDebt)
final overdueCardDebtProvider = AutoDisposeFutureProvider<int>.internal(
  overdueCardDebt,
  name: r'overdueCardDebtProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overdueCardDebtHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverdueCardDebtRef = AutoDisposeFutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
