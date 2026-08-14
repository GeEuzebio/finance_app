// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountRepositoryHash() => r'25bda2f17f16c111dd7a63af2172074cf75163f8';

/// See also [accountRepository].
@ProviderFor(accountRepository)
final accountRepositoryProvider =
    AutoDisposeProvider<AccountRepository>.internal(
  accountRepository,
  name: r'accountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountRepositoryRef = AutoDisposeProviderRef<AccountRepository>;
String _$accountsControllerHash() =>
    r'9d9d4a3702eb1ab51cc9c248968808e8680c2d38';

/// See also [AccountsController].
@ProviderFor(AccountsController)
final accountsControllerProvider = AutoDisposeAsyncNotifierProvider<
    AccountsController, List<Account>>.internal(
  AccountsController.new,
  name: r'accountsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountsController = AutoDisposeAsyncNotifier<List<Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
