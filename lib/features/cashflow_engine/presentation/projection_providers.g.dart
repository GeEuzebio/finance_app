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
String _$getCommittedCardBalanceUseCaseHash() =>
    r'cce2fc6433aeddebf686412b4a3f7095cdae6b15';

/// See also [getCommittedCardBalanceUseCase].
@ProviderFor(getCommittedCardBalanceUseCase)
final getCommittedCardBalanceUseCaseProvider =
    AutoDisposeProvider<GetCommittedCardBalance>.internal(
  getCommittedCardBalanceUseCase,
  name: r'getCommittedCardBalanceUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCommittedCardBalanceUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCommittedCardBalanceUseCaseRef
    = AutoDisposeProviderRef<GetCommittedCardBalance>;
String _$getDayLedgerUseCaseHash() =>
    r'071ef6aba41dedee832ee1f59b756f252252a289';

/// See also [getDayLedgerUseCase].
@ProviderFor(getDayLedgerUseCase)
final getDayLedgerUseCaseProvider = AutoDisposeProvider<GetDayLedger>.internal(
  getDayLedgerUseCase,
  name: r'getDayLedgerUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getDayLedgerUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDayLedgerUseCaseRef = AutoDisposeProviderRef<GetDayLedger>;
String _$committedCardBalanceHash() =>
    r'3e94a5b20f77b67a58ca443e2407d6fb2f4dae9c';

/// Quanto do saldo de hoje já está comprometido com fatura de cartão em
/// aberto (Backlog, "análise de risco" parte 2 — docs/ROADMAP.md). É um
/// retrato de agora, não um valor por dia da projeção: a própria engine
/// já sintetiza o débito da fatura na data de vencimento
/// (`project_cashflow.dart` §3), então aplicar esse desconto em todo dia
/// do horizonte contaria a mesma fatura duas vezes a partir do
/// vencimento.
///
/// Copied from [committedCardBalance].
@ProviderFor(committedCardBalance)
final committedCardBalanceProvider = AutoDisposeFutureProvider<int>.internal(
  committedCardBalance,
  name: r'committedCardBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$committedCardBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CommittedCardBalanceRef = AutoDisposeFutureProviderRef<int>;
String _$monthlyProjectionHash() => r'ff021517242018ac0e985ed4453d35207b600c0f';

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

/// Projeção de um mês inteiro (M7, #026 — seletor de mês/ano na
/// Projeção). Substitui o antigo horizonte "N dias a partir de hoje": a
/// engine já aceita qualquer `horizonStart`/`horizonEnd`, então navegar
/// mês a mês é só trocar os dois parâmetros, sem tocar na engine.
///
/// Copied from [monthlyProjection].
@ProviderFor(monthlyProjection)
const monthlyProjectionProvider = MonthlyProjectionFamily();

/// Projeção de um mês inteiro (M7, #026 — seletor de mês/ano na
/// Projeção). Substitui o antigo horizonte "N dias a partir de hoje": a
/// engine já aceita qualquer `horizonStart`/`horizonEnd`, então navegar
/// mês a mês é só trocar os dois parâmetros, sem tocar na engine.
///
/// Copied from [monthlyProjection].
class MonthlyProjectionFamily extends Family<AsyncValue<List<DailyBalance>>> {
  /// Projeção de um mês inteiro (M7, #026 — seletor de mês/ano na
  /// Projeção). Substitui o antigo horizonte "N dias a partir de hoje": a
  /// engine já aceita qualquer `horizonStart`/`horizonEnd`, então navegar
  /// mês a mês é só trocar os dois parâmetros, sem tocar na engine.
  ///
  /// Copied from [monthlyProjection].
  const MonthlyProjectionFamily();

  /// Projeção de um mês inteiro (M7, #026 — seletor de mês/ano na
  /// Projeção). Substitui o antigo horizonte "N dias a partir de hoje": a
  /// engine já aceita qualquer `horizonStart`/`horizonEnd`, então navegar
  /// mês a mês é só trocar os dois parâmetros, sem tocar na engine.
  ///
  /// Copied from [monthlyProjection].
  MonthlyProjectionProvider call({
    required int year,
    required int month,
  }) {
    return MonthlyProjectionProvider(
      year: year,
      month: month,
    );
  }

  @override
  MonthlyProjectionProvider getProviderOverride(
    covariant MonthlyProjectionProvider provider,
  ) {
    return call(
      year: provider.year,
      month: provider.month,
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
  String? get name => r'monthlyProjectionProvider';
}

/// Projeção de um mês inteiro (M7, #026 — seletor de mês/ano na
/// Projeção). Substitui o antigo horizonte "N dias a partir de hoje": a
/// engine já aceita qualquer `horizonStart`/`horizonEnd`, então navegar
/// mês a mês é só trocar os dois parâmetros, sem tocar na engine.
///
/// Copied from [monthlyProjection].
class MonthlyProjectionProvider
    extends AutoDisposeFutureProvider<List<DailyBalance>> {
  /// Projeção de um mês inteiro (M7, #026 — seletor de mês/ano na
  /// Projeção). Substitui o antigo horizonte "N dias a partir de hoje": a
  /// engine já aceita qualquer `horizonStart`/`horizonEnd`, então navegar
  /// mês a mês é só trocar os dois parâmetros, sem tocar na engine.
  ///
  /// Copied from [monthlyProjection].
  MonthlyProjectionProvider({
    required int year,
    required int month,
  }) : this._internal(
          (ref) => monthlyProjection(
            ref as MonthlyProjectionRef,
            year: year,
            month: month,
          ),
          from: monthlyProjectionProvider,
          name: r'monthlyProjectionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyProjectionHash,
          dependencies: MonthlyProjectionFamily._dependencies,
          allTransitiveDependencies:
              MonthlyProjectionFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  MonthlyProjectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<List<DailyBalance>> Function(MonthlyProjectionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyProjectionProvider._internal(
        (ref) => create(ref as MonthlyProjectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DailyBalance>> createElement() {
    return _MonthlyProjectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyProjectionProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyProjectionRef on AutoDisposeFutureProviderRef<List<DailyBalance>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyProjectionProviderElement
    extends AutoDisposeFutureProviderElement<List<DailyBalance>>
    with MonthlyProjectionRef {
  _MonthlyProjectionProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyProjectionProvider).year;
  @override
  int get month => (origin as MonthlyProjectionProvider).month;
}

String _$dayLedgerHash() => r'2748573f48eff47c80776eee6e357ea6446c39e6';

/// Detalhamento de um dia (M7, #026) — o que a grade da Projeção resume
/// como "Diferença", item a item.
///
/// Copied from [dayLedger].
@ProviderFor(dayLedger)
const dayLedgerProvider = DayLedgerFamily();

/// Detalhamento de um dia (M7, #026) — o que a grade da Projeção resume
/// como "Diferença", item a item.
///
/// Copied from [dayLedger].
class DayLedgerFamily extends Family<AsyncValue<List<CheckInItem>>> {
  /// Detalhamento de um dia (M7, #026) — o que a grade da Projeção resume
  /// como "Diferença", item a item.
  ///
  /// Copied from [dayLedger].
  const DayLedgerFamily();

  /// Detalhamento de um dia (M7, #026) — o que a grade da Projeção resume
  /// como "Diferença", item a item.
  ///
  /// Copied from [dayLedger].
  DayLedgerProvider call({
    required DateOnly day,
  }) {
    return DayLedgerProvider(
      day: day,
    );
  }

  @override
  DayLedgerProvider getProviderOverride(
    covariant DayLedgerProvider provider,
  ) {
    return call(
      day: provider.day,
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
  String? get name => r'dayLedgerProvider';
}

/// Detalhamento de um dia (M7, #026) — o que a grade da Projeção resume
/// como "Diferença", item a item.
///
/// Copied from [dayLedger].
class DayLedgerProvider extends AutoDisposeFutureProvider<List<CheckInItem>> {
  /// Detalhamento de um dia (M7, #026) — o que a grade da Projeção resume
  /// como "Diferença", item a item.
  ///
  /// Copied from [dayLedger].
  DayLedgerProvider({
    required DateOnly day,
  }) : this._internal(
          (ref) => dayLedger(
            ref as DayLedgerRef,
            day: day,
          ),
          from: dayLedgerProvider,
          name: r'dayLedgerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dayLedgerHash,
          dependencies: DayLedgerFamily._dependencies,
          allTransitiveDependencies: DayLedgerFamily._allTransitiveDependencies,
          day: day,
        );

  DayLedgerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.day,
  }) : super.internal();

  final DateOnly day;

  @override
  Override overrideWith(
    FutureOr<List<CheckInItem>> Function(DayLedgerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DayLedgerProvider._internal(
        (ref) => create(ref as DayLedgerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        day: day,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CheckInItem>> createElement() {
    return _DayLedgerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DayLedgerProvider && other.day == day;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, day.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DayLedgerRef on AutoDisposeFutureProviderRef<List<CheckInItem>> {
  /// The parameter `day` of this provider.
  DateOnly get day;
}

class _DayLedgerProviderElement
    extends AutoDisposeFutureProviderElement<List<CheckInItem>>
    with DayLedgerRef {
  _DayLedgerProviderElement(super.provider);

  @override
  DateOnly get day => (origin as DayLedgerProvider).day;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
