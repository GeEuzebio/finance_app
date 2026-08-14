// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getDailyProjectionUseCaseHash() =>
    r'9a8bc218fca7bd7a9a3e041f453541f1c644c21b';

/// See also [getDailyProjectionUseCase].
@ProviderFor(getDailyProjectionUseCase)
final getDailyProjectionUseCaseProvider =
    AutoDisposeProvider<GetDailyProjection>.internal(
  getDailyProjectionUseCase,
  name: r'getDailyProjectionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getDailyProjectionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDailyProjectionUseCaseRef
    = AutoDisposeProviderRef<GetDailyProjection>;
String _$dailyProjectionHash() => r'5a4994ef61c3b460af7efaf6b7a1424d98cb7fe5';

/// Horizonte fixo de 30 dias a partir de hoje — suficiente pro check-in do
/// dia a dia; horizonte de 12 meses (docs/CASHFLOW_ENGINE.md) fica pra uma
/// visão de longo prazo futura, não pra essa lista.
///
/// Copied from [dailyProjection].
@ProviderFor(dailyProjection)
final dailyProjectionProvider =
    AutoDisposeFutureProvider<List<DailyBalance>>.internal(
  dailyProjection,
  name: r'dailyProjectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dailyProjectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyProjectionRef = AutoDisposeFutureProviderRef<List<DailyBalance>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
