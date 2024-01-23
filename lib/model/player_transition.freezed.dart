// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_transition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PlayerTransition _$PlayerTransitionFromJson(Map<String, dynamic> json) {
  return _PlayerTransition.fromJson(json);
}

/// @nodoc
mixin _$PlayerTransition {
  Player get player => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerTransitionCopyWith<PlayerTransition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerTransitionCopyWith<$Res> {
  factory $PlayerTransitionCopyWith(
          PlayerTransition value, $Res Function(PlayerTransition) then) =
      _$PlayerTransitionCopyWithImpl<$Res, PlayerTransition>;
  @useResult
  $Res call({Player player, int duration});

  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class _$PlayerTransitionCopyWithImpl<$Res, $Val extends PlayerTransition>
    implements $PlayerTransitionCopyWith<$Res> {
  _$PlayerTransitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? duration = null,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerTransitionImplCopyWith<$Res>
    implements $PlayerTransitionCopyWith<$Res> {
  factory _$$PlayerTransitionImplCopyWith(_$PlayerTransitionImpl value,
          $Res Function(_$PlayerTransitionImpl) then) =
      __$$PlayerTransitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player player, int duration});

  @override
  $PlayerCopyWith<$Res> get player;
}

/// @nodoc
class __$$PlayerTransitionImplCopyWithImpl<$Res>
    extends _$PlayerTransitionCopyWithImpl<$Res, _$PlayerTransitionImpl>
    implements _$$PlayerTransitionImplCopyWith<$Res> {
  __$$PlayerTransitionImplCopyWithImpl(_$PlayerTransitionImpl _value,
      $Res Function(_$PlayerTransitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? duration = null,
  }) {
    return _then(_$PlayerTransitionImpl(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerTransitionImpl extends _PlayerTransition {
  const _$PlayerTransitionImpl({required this.player, required this.duration})
      : super._();

  factory _$PlayerTransitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerTransitionImplFromJson(json);

  @override
  final Player player;
  @override
  final int duration;

  @override
  String toString() {
    return 'PlayerTransition(player: $player, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerTransitionImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, player, duration);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerTransitionImplCopyWith<_$PlayerTransitionImpl> get copyWith =>
      __$$PlayerTransitionImplCopyWithImpl<_$PlayerTransitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerTransitionImplToJson(
      this,
    );
  }
}

abstract class _PlayerTransition extends PlayerTransition {
  const factory _PlayerTransition(
      {required final Player player,
      required final int duration}) = _$PlayerTransitionImpl;
  const _PlayerTransition._() : super._();

  factory _PlayerTransition.fromJson(Map<String, dynamic> json) =
      _$PlayerTransitionImpl.fromJson;

  @override
  Player get player;
  @override
  int get duration;
  @override
  @JsonKey(ignore: true)
  _$$PlayerTransitionImplCopyWith<_$PlayerTransitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
