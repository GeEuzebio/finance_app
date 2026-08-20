// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_insights.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FinancialInsights {
  List<String> get suggestions => throw _privateConstructorUsedError;
  DateTime get generatedAt => throw _privateConstructorUsedError;

  /// Create a copy of FinancialInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FinancialInsightsCopyWith<FinancialInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialInsightsCopyWith<$Res> {
  factory $FinancialInsightsCopyWith(
          FinancialInsights value, $Res Function(FinancialInsights) then) =
      _$FinancialInsightsCopyWithImpl<$Res, FinancialInsights>;
  @useResult
  $Res call({List<String> suggestions, DateTime generatedAt});
}

/// @nodoc
class _$FinancialInsightsCopyWithImpl<$Res, $Val extends FinancialInsights>
    implements $FinancialInsightsCopyWith<$Res> {
  _$FinancialInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FinancialInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestions = null,
    Object? generatedAt = null,
  }) {
    return _then(_value.copyWith(
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialInsightsImplCopyWith<$Res>
    implements $FinancialInsightsCopyWith<$Res> {
  factory _$$FinancialInsightsImplCopyWith(_$FinancialInsightsImpl value,
          $Res Function(_$FinancialInsightsImpl) then) =
      __$$FinancialInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> suggestions, DateTime generatedAt});
}

/// @nodoc
class __$$FinancialInsightsImplCopyWithImpl<$Res>
    extends _$FinancialInsightsCopyWithImpl<$Res, _$FinancialInsightsImpl>
    implements _$$FinancialInsightsImplCopyWith<$Res> {
  __$$FinancialInsightsImplCopyWithImpl(_$FinancialInsightsImpl _value,
      $Res Function(_$FinancialInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FinancialInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestions = null,
    Object? generatedAt = null,
  }) {
    return _then(_$FinancialInsightsImpl(
      suggestions: null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      generatedAt: null == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$FinancialInsightsImpl implements _FinancialInsights {
  const _$FinancialInsightsImpl(
      {required final List<String> suggestions, required this.generatedAt})
      : _suggestions = suggestions;

  final List<String> _suggestions;
  @override
  List<String> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  final DateTime generatedAt;

  @override
  String toString() {
    return 'FinancialInsights(suggestions: $suggestions, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialInsightsImpl &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_suggestions), generatedAt);

  /// Create a copy of FinancialInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialInsightsImplCopyWith<_$FinancialInsightsImpl> get copyWith =>
      __$$FinancialInsightsImplCopyWithImpl<_$FinancialInsightsImpl>(
          this, _$identity);
}

abstract class _FinancialInsights implements FinancialInsights {
  const factory _FinancialInsights(
      {required final List<String> suggestions,
      required final DateTime generatedAt}) = _$FinancialInsightsImpl;

  @override
  List<String> get suggestions;
  @override
  DateTime get generatedAt;

  /// Create a copy of FinancialInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinancialInsightsImplCopyWith<_$FinancialInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
