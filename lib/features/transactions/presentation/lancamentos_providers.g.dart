// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lancamentos_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionRepositoryHash() =>
    r'f7b3a51a50ec56c66727472c41e4f5ac08ece1c5';

/// See also [transactionRepository].
@ProviderFor(transactionRepository)
final transactionRepositoryProvider =
    AutoDisposeProvider<TransactionRepository>.internal(
  transactionRepository,
  name: r'transactionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionRepositoryRef
    = AutoDisposeProviderRef<TransactionRepository>;
String _$recurrenceRepositoryHash() =>
    r'9739733153e36d0d99ce5da3813b885ba0a3ea5d';

/// See also [recurrenceRepository].
@ProviderFor(recurrenceRepository)
final recurrenceRepositoryProvider =
    AutoDisposeProvider<RecurrenceRepository>.internal(
  recurrenceRepository,
  name: r'recurrenceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recurrenceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecurrenceRepositoryRef = AutoDisposeProviderRef<RecurrenceRepository>;
String _$createTransactionUseCaseHash() =>
    r'ec2289924b235c9c487a6568f713d70f178a2a09';

/// See also [createTransactionUseCase].
@ProviderFor(createTransactionUseCase)
final createTransactionUseCaseProvider =
    AutoDisposeProvider<CreateTransaction>.internal(
  createTransactionUseCase,
  name: r'createTransactionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createTransactionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateTransactionUseCaseRef = AutoDisposeProviderRef<CreateTransaction>;
String _$createRecurrenceRuleUseCaseHash() =>
    r'495cf2d73121854f5f5470dfba925d4a66d96a97';

/// See also [createRecurrenceRuleUseCase].
@ProviderFor(createRecurrenceRuleUseCase)
final createRecurrenceRuleUseCaseProvider =
    AutoDisposeProvider<CreateRecurrenceRule>.internal(
  createRecurrenceRuleUseCase,
  name: r'createRecurrenceRuleUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createRecurrenceRuleUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateRecurrenceRuleUseCaseRef
    = AutoDisposeProviderRef<CreateRecurrenceRule>;
String _$lancamentosControllerHash() =>
    r'9d9dea19e754e91e707f6992a9eb58747fff49e9';

/// See also [LancamentosController].
@ProviderFor(LancamentosController)
final lancamentosControllerProvider = AutoDisposeAsyncNotifierProvider<
    LancamentosController, LancamentosData>.internal(
  LancamentosController.new,
  name: r'lancamentosControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lancamentosControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LancamentosController = AutoDisposeAsyncNotifier<LancamentosData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
