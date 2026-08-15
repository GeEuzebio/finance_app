// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_cards_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$creditCardRepositoryHash() =>
    r'451626c2be48f2e79f17fbb34938fb44a5d309a9';

/// See also [creditCardRepository].
@ProviderFor(creditCardRepository)
final creditCardRepositoryProvider =
    AutoDisposeProvider<CreditCardRepository>.internal(
  creditCardRepository,
  name: r'creditCardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$creditCardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreditCardRepositoryRef = AutoDisposeProviderRef<CreditCardRepository>;
String _$findOrCreateInvoiceUseCaseHash() =>
    r'81d6097457e839135f54cf65c95fcc2073adcfb6';

/// See also [findOrCreateInvoiceUseCase].
@ProviderFor(findOrCreateInvoiceUseCase)
final findOrCreateInvoiceUseCaseProvider =
    AutoDisposeProvider<FindOrCreateInvoice>.internal(
  findOrCreateInvoiceUseCase,
  name: r'findOrCreateInvoiceUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$findOrCreateInvoiceUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FindOrCreateInvoiceUseCaseRef
    = AutoDisposeProviderRef<FindOrCreateInvoice>;
String _$registerCardPurchaseUseCaseHash() =>
    r'9f12130f1ea9f4c29e10bf4bb57babaafbdab9e1';

/// See also [registerCardPurchaseUseCase].
@ProviderFor(registerCardPurchaseUseCase)
final registerCardPurchaseUseCaseProvider =
    AutoDisposeProvider<RegisterCardPurchase>.internal(
  registerCardPurchaseUseCase,
  name: r'registerCardPurchaseUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$registerCardPurchaseUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegisterCardPurchaseUseCaseRef
    = AutoDisposeProviderRef<RegisterCardPurchase>;
String _$payInvoiceUseCaseHash() => r'634471027f156c38138df94ddb74b7e593dcb78c';

/// See also [payInvoiceUseCase].
@ProviderFor(payInvoiceUseCase)
final payInvoiceUseCaseProvider = AutoDisposeProvider<PayInvoice>.internal(
  payInvoiceUseCase,
  name: r'payInvoiceUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$payInvoiceUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PayInvoiceUseCaseRef = AutoDisposeProviderRef<PayInvoice>;
String _$reverseInvoiceItemUseCaseHash() =>
    r'b3b865c11fc0a60e8eb857d494fbbe81f7da53ba';

/// See also [reverseInvoiceItemUseCase].
@ProviderFor(reverseInvoiceItemUseCase)
final reverseInvoiceItemUseCaseProvider =
    AutoDisposeProvider<ReverseInvoiceItem>.internal(
  reverseInvoiceItemUseCase,
  name: r'reverseInvoiceItemUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reverseInvoiceItemUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReverseInvoiceItemUseCaseRef
    = AutoDisposeProviderRef<ReverseInvoiceItem>;
String _$creditCardsControllerHash() =>
    r'62f520c54a4e6b493062819338e70166c7d992e8';

/// See also [CreditCardsController].
@ProviderFor(CreditCardsController)
final creditCardsControllerProvider = AutoDisposeAsyncNotifierProvider<
    CreditCardsController, List<CreditCard>>.internal(
  CreditCardsController.new,
  name: r'creditCardsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$creditCardsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreditCardsController = AutoDisposeAsyncNotifier<List<CreditCard>>;
String _$cardDetailControllerHash() =>
    r'9dff10744f0ecf047628489ed6ee0451e61975c1';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CardDetailController
    extends BuildlessAutoDisposeAsyncNotifier<CardDetail> {
  late final String cardId;

  FutureOr<CardDetail> build(
    String cardId,
  );
}

/// See also [CardDetailController].
@ProviderFor(CardDetailController)
const cardDetailControllerProvider = CardDetailControllerFamily();

/// See also [CardDetailController].
class CardDetailControllerFamily extends Family<AsyncValue<CardDetail>> {
  /// See also [CardDetailController].
  const CardDetailControllerFamily();

  /// See also [CardDetailController].
  CardDetailControllerProvider call(
    String cardId,
  ) {
    return CardDetailControllerProvider(
      cardId,
    );
  }

  @override
  CardDetailControllerProvider getProviderOverride(
    covariant CardDetailControllerProvider provider,
  ) {
    return call(
      provider.cardId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cardDetailControllerProvider';
}

/// See also [CardDetailController].
class CardDetailControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CardDetailController, CardDetail> {
  /// See also [CardDetailController].
  CardDetailControllerProvider(
    String cardId,
  ) : this._internal(
          () => CardDetailController()..cardId = cardId,
          from: cardDetailControllerProvider,
          name: r'cardDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cardDetailControllerHash,
          dependencies: CardDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              CardDetailControllerFamily._allTransitiveDependencies,
          cardId: cardId,
        );

  CardDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cardId,
  }) : super.internal();

  final String cardId;

  @override
  FutureOr<CardDetail> runNotifierBuild(
    covariant CardDetailController notifier,
  ) {
    return notifier.build(
      cardId,
    );
  }

  @override
  Override overrideWith(CardDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CardDetailControllerProvider._internal(
        () => create()..cardId = cardId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cardId: cardId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CardDetailController, CardDetail>
      createElement() {
    return _CardDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CardDetailControllerProvider && other.cardId == cardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CardDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<CardDetail> {
  /// The parameter `cardId` of this provider.
  String get cardId;
}

class _CardDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CardDetailController,
        CardDetail> with CardDetailControllerRef {
  _CardDetailControllerProviderElement(super.provider);

  @override
  String get cardId => (origin as CardDetailControllerProvider).cardId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
