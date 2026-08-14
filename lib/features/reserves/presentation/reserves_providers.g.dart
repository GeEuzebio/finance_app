// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserves_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reserveRepositoryHash() => r'1da22eafabf6551b13f3ff3e4c3ae15227070e09';

/// See also [reserveRepository].
@ProviderFor(reserveRepository)
final reserveRepositoryProvider =
    AutoDisposeProvider<ReserveRepository>.internal(
  reserveRepository,
  name: r'reserveRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reserveRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReserveRepositoryRef = AutoDisposeProviderRef<ReserveRepository>;
String _$createReserveUseCaseHash() =>
    r'7391693d1202e21199768a2249cfd7261a586a49';

/// See also [createReserveUseCase].
@ProviderFor(createReserveUseCase)
final createReserveUseCaseProvider =
    AutoDisposeProvider<CreateReserve>.internal(
  createReserveUseCase,
  name: r'createReserveUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createReserveUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateReserveUseCaseRef = AutoDisposeProviderRef<CreateReserve>;
String _$contributeToReserveUseCaseHash() =>
    r'701779fa0a7e469e771e81401e1c76bbbf56ce7b';

/// See also [contributeToReserveUseCase].
@ProviderFor(contributeToReserveUseCase)
final contributeToReserveUseCaseProvider =
    AutoDisposeProvider<ContributeToReserve>.internal(
  contributeToReserveUseCase,
  name: r'contributeToReserveUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contributeToReserveUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContributeToReserveUseCaseRef
    = AutoDisposeProviderRef<ContributeToReserve>;
String _$withdrawFromReserveUseCaseHash() =>
    r'7f79d59a1443b7387d9c0b25090a6b56f0c4ff89';

/// See also [withdrawFromReserveUseCase].
@ProviderFor(withdrawFromReserveUseCase)
final withdrawFromReserveUseCaseProvider =
    AutoDisposeProvider<WithdrawFromReserve>.internal(
  withdrawFromReserveUseCase,
  name: r'withdrawFromReserveUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$withdrawFromReserveUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WithdrawFromReserveUseCaseRef
    = AutoDisposeProviderRef<WithdrawFromReserve>;
String _$reservesControllerHash() =>
    r'50eb0bb35567fdd96f600026fc97a7d1c80419da';

/// See also [ReservesController].
@ProviderFor(ReservesController)
final reservesControllerProvider = AutoDisposeAsyncNotifierProvider<
    ReservesController, List<Reserve>>.internal(
  ReservesController.new,
  name: r'reservesControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reservesControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReservesController = AutoDisposeAsyncNotifier<List<Reserve>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
