// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlySummary {
  int get incomeCents => throw _privateConstructorUsedError;
  int get expensesCents => throw _privateConstructorUsedError;
  int get cardSpendCents => throw _privateConstructorUsedError;
  int get costOfLivingCents => throw _privateConstructorUsedError;
  int get dailyCostCents => throw _privateConstructorUsedError;
  int get savedCents => throw _privateConstructorUsedError;
  double get savingsPercent => throw _privateConstructorUsedError;
  bool get isSavingsOnTarget =>
      throw _privateConstructorUsedError; // Mesma composição de custo de vida (saídas + gasto de cartão),
// bucketada por categoria — soma dos valores bate com
// costOfLivingCents (M7, #029).
  Map<TransactionCategory, int> get categoryCents =>
      throw _privateConstructorUsedError;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlySummaryCopyWith<MonthlySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlySummaryCopyWith<$Res> {
  factory $MonthlySummaryCopyWith(
          MonthlySummary value, $Res Function(MonthlySummary) then) =
      _$MonthlySummaryCopyWithImpl<$Res, MonthlySummary>;
  @useResult
  $Res call(
      {int incomeCents,
      int expensesCents,
      int cardSpendCents,
      int costOfLivingCents,
      int dailyCostCents,
      int savedCents,
      double savingsPercent,
      bool isSavingsOnTarget,
      Map<TransactionCategory, int> categoryCents});
}

/// @nodoc
class _$MonthlySummaryCopyWithImpl<$Res, $Val extends MonthlySummary>
    implements $MonthlySummaryCopyWith<$Res> {
  _$MonthlySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incomeCents = null,
    Object? expensesCents = null,
    Object? cardSpendCents = null,
    Object? costOfLivingCents = null,
    Object? dailyCostCents = null,
    Object? savedCents = null,
    Object? savingsPercent = null,
    Object? isSavingsOnTarget = null,
    Object? categoryCents = null,
  }) {
    return _then(_value.copyWith(
      incomeCents: null == incomeCents
          ? _value.incomeCents
          : incomeCents // ignore: cast_nullable_to_non_nullable
              as int,
      expensesCents: null == expensesCents
          ? _value.expensesCents
          : expensesCents // ignore: cast_nullable_to_non_nullable
              as int,
      cardSpendCents: null == cardSpendCents
          ? _value.cardSpendCents
          : cardSpendCents // ignore: cast_nullable_to_non_nullable
              as int,
      costOfLivingCents: null == costOfLivingCents
          ? _value.costOfLivingCents
          : costOfLivingCents // ignore: cast_nullable_to_non_nullable
              as int,
      dailyCostCents: null == dailyCostCents
          ? _value.dailyCostCents
          : dailyCostCents // ignore: cast_nullable_to_non_nullable
              as int,
      savedCents: null == savedCents
          ? _value.savedCents
          : savedCents // ignore: cast_nullable_to_non_nullable
              as int,
      savingsPercent: null == savingsPercent
          ? _value.savingsPercent
          : savingsPercent // ignore: cast_nullable_to_non_nullable
              as double,
      isSavingsOnTarget: null == isSavingsOnTarget
          ? _value.isSavingsOnTarget
          : isSavingsOnTarget // ignore: cast_nullable_to_non_nullable
              as bool,
      categoryCents: null == categoryCents
          ? _value.categoryCents
          : categoryCents // ignore: cast_nullable_to_non_nullable
              as Map<TransactionCategory, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlySummaryImplCopyWith<$Res>
    implements $MonthlySummaryCopyWith<$Res> {
  factory _$$MonthlySummaryImplCopyWith(_$MonthlySummaryImpl value,
          $Res Function(_$MonthlySummaryImpl) then) =
      __$$MonthlySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int incomeCents,
      int expensesCents,
      int cardSpendCents,
      int costOfLivingCents,
      int dailyCostCents,
      int savedCents,
      double savingsPercent,
      bool isSavingsOnTarget,
      Map<TransactionCategory, int> categoryCents});
}

/// @nodoc
class __$$MonthlySummaryImplCopyWithImpl<$Res>
    extends _$MonthlySummaryCopyWithImpl<$Res, _$MonthlySummaryImpl>
    implements _$$MonthlySummaryImplCopyWith<$Res> {
  __$$MonthlySummaryImplCopyWithImpl(
      _$MonthlySummaryImpl _value, $Res Function(_$MonthlySummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incomeCents = null,
    Object? expensesCents = null,
    Object? cardSpendCents = null,
    Object? costOfLivingCents = null,
    Object? dailyCostCents = null,
    Object? savedCents = null,
    Object? savingsPercent = null,
    Object? isSavingsOnTarget = null,
    Object? categoryCents = null,
  }) {
    return _then(_$MonthlySummaryImpl(
      incomeCents: null == incomeCents
          ? _value.incomeCents
          : incomeCents // ignore: cast_nullable_to_non_nullable
              as int,
      expensesCents: null == expensesCents
          ? _value.expensesCents
          : expensesCents // ignore: cast_nullable_to_non_nullable
              as int,
      cardSpendCents: null == cardSpendCents
          ? _value.cardSpendCents
          : cardSpendCents // ignore: cast_nullable_to_non_nullable
              as int,
      costOfLivingCents: null == costOfLivingCents
          ? _value.costOfLivingCents
          : costOfLivingCents // ignore: cast_nullable_to_non_nullable
              as int,
      dailyCostCents: null == dailyCostCents
          ? _value.dailyCostCents
          : dailyCostCents // ignore: cast_nullable_to_non_nullable
              as int,
      savedCents: null == savedCents
          ? _value.savedCents
          : savedCents // ignore: cast_nullable_to_non_nullable
              as int,
      savingsPercent: null == savingsPercent
          ? _value.savingsPercent
          : savingsPercent // ignore: cast_nullable_to_non_nullable
              as double,
      isSavingsOnTarget: null == isSavingsOnTarget
          ? _value.isSavingsOnTarget
          : isSavingsOnTarget // ignore: cast_nullable_to_non_nullable
              as bool,
      categoryCents: null == categoryCents
          ? _value._categoryCents
          : categoryCents // ignore: cast_nullable_to_non_nullable
              as Map<TransactionCategory, int>,
    ));
  }
}

/// @nodoc

class _$MonthlySummaryImpl implements _MonthlySummary {
  const _$MonthlySummaryImpl(
      {required this.incomeCents,
      required this.expensesCents,
      required this.cardSpendCents,
      required this.costOfLivingCents,
      required this.dailyCostCents,
      required this.savedCents,
      required this.savingsPercent,
      required this.isSavingsOnTarget,
      required final Map<TransactionCategory, int> categoryCents})
      : _categoryCents = categoryCents;

  @override
  final int incomeCents;
  @override
  final int expensesCents;
  @override
  final int cardSpendCents;
  @override
  final int costOfLivingCents;
  @override
  final int dailyCostCents;
  @override
  final int savedCents;
  @override
  final double savingsPercent;
  @override
  final bool isSavingsOnTarget;
// Mesma composição de custo de vida (saídas + gasto de cartão),
// bucketada por categoria — soma dos valores bate com
// costOfLivingCents (M7, #029).
  final Map<TransactionCategory, int> _categoryCents;
// Mesma composição de custo de vida (saídas + gasto de cartão),
// bucketada por categoria — soma dos valores bate com
// costOfLivingCents (M7, #029).
  @override
  Map<TransactionCategory, int> get categoryCents {
    if (_categoryCents is EqualUnmodifiableMapView) return _categoryCents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryCents);
  }

  @override
  String toString() {
    return 'MonthlySummary(incomeCents: $incomeCents, expensesCents: $expensesCents, cardSpendCents: $cardSpendCents, costOfLivingCents: $costOfLivingCents, dailyCostCents: $dailyCostCents, savedCents: $savedCents, savingsPercent: $savingsPercent, isSavingsOnTarget: $isSavingsOnTarget, categoryCents: $categoryCents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlySummaryImpl &&
            (identical(other.incomeCents, incomeCents) ||
                other.incomeCents == incomeCents) &&
            (identical(other.expensesCents, expensesCents) ||
                other.expensesCents == expensesCents) &&
            (identical(other.cardSpendCents, cardSpendCents) ||
                other.cardSpendCents == cardSpendCents) &&
            (identical(other.costOfLivingCents, costOfLivingCents) ||
                other.costOfLivingCents == costOfLivingCents) &&
            (identical(other.dailyCostCents, dailyCostCents) ||
                other.dailyCostCents == dailyCostCents) &&
            (identical(other.savedCents, savedCents) ||
                other.savedCents == savedCents) &&
            (identical(other.savingsPercent, savingsPercent) ||
                other.savingsPercent == savingsPercent) &&
            (identical(other.isSavingsOnTarget, isSavingsOnTarget) ||
                other.isSavingsOnTarget == isSavingsOnTarget) &&
            const DeepCollectionEquality()
                .equals(other._categoryCents, _categoryCents));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      incomeCents,
      expensesCents,
      cardSpendCents,
      costOfLivingCents,
      dailyCostCents,
      savedCents,
      savingsPercent,
      isSavingsOnTarget,
      const DeepCollectionEquality().hash(_categoryCents));

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlySummaryImplCopyWith<_$MonthlySummaryImpl> get copyWith =>
      __$$MonthlySummaryImplCopyWithImpl<_$MonthlySummaryImpl>(
          this, _$identity);
}

abstract class _MonthlySummary implements MonthlySummary {
  const factory _MonthlySummary(
          {required final int incomeCents,
          required final int expensesCents,
          required final int cardSpendCents,
          required final int costOfLivingCents,
          required final int dailyCostCents,
          required final int savedCents,
          required final double savingsPercent,
          required final bool isSavingsOnTarget,
          required final Map<TransactionCategory, int> categoryCents}) =
      _$MonthlySummaryImpl;

  @override
  int get incomeCents;
  @override
  int get expensesCents;
  @override
  int get cardSpendCents;
  @override
  int get costOfLivingCents;
  @override
  int get dailyCostCents;
  @override
  int get savedCents;
  @override
  double get savingsPercent;
  @override
  bool
      get isSavingsOnTarget; // Mesma composição de custo de vida (saídas + gasto de cartão),
// bucketada por categoria — soma dos valores bate com
// costOfLivingCents (M7, #029).
  @override
  Map<TransactionCategory, int> get categoryCents;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlySummaryImplCopyWith<_$MonthlySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
