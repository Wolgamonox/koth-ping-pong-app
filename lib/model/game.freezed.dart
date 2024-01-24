// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$Game {
  List<Player> get players => throw _privateConstructorUsedError;
  List<PlayerTransition> get transitions => throw _privateConstructorUsedError;
  GamePhase get phase => throw _privateConstructorUsedError;
  Player? get currentKing => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GameCopyWith<Game> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res, Game>;
  @useResult
  $Res call(
      {List<Player> players,
      List<PlayerTransition> transitions,
      GamePhase phase,
      Player? currentKing});

  $PlayerCopyWith<$Res>? get currentKing;
}

/// @nodoc
class _$GameCopyWithImpl<$Res, $Val extends Game>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? transitions = null,
    Object? phase = null,
    Object? currentKing = freezed,
  }) {
    return _then(_value.copyWith(
      players: null == players
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      transitions: null == transitions
          ? _value.transitions
          : transitions // ignore: cast_nullable_to_non_nullable
              as List<PlayerTransition>,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      currentKing: freezed == currentKing
          ? _value.currentKing
          : currentKing // ignore: cast_nullable_to_non_nullable
              as Player?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res>? get currentKing {
    if (_value.currentKing == null) {
      return null;
    }

    return $PlayerCopyWith<$Res>(_value.currentKing!, (value) {
      return _then(_value.copyWith(currentKing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameImplCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$$GameImplCopyWith(
          _$GameImpl value, $Res Function(_$GameImpl) then) =
      __$$GameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Player> players,
      List<PlayerTransition> transitions,
      GamePhase phase,
      Player? currentKing});

  @override
  $PlayerCopyWith<$Res>? get currentKing;
}

/// @nodoc
class __$$GameImplCopyWithImpl<$Res>
    extends _$GameCopyWithImpl<$Res, _$GameImpl>
    implements _$$GameImplCopyWith<$Res> {
  __$$GameImplCopyWithImpl(_$GameImpl _value, $Res Function(_$GameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? transitions = null,
    Object? phase = null,
    Object? currentKing = freezed,
  }) {
    return _then(_$GameImpl(
      players: null == players
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as List<Player>,
      transitions: null == transitions
          ? _value._transitions
          : transitions // ignore: cast_nullable_to_non_nullable
              as List<PlayerTransition>,
      phase: null == phase
          ? _value.phase
          : phase // ignore: cast_nullable_to_non_nullable
              as GamePhase,
      currentKing: freezed == currentKing
          ? _value.currentKing
          : currentKing // ignore: cast_nullable_to_non_nullable
              as Player?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GameImpl implements _Game {
  _$GameImpl(
      {required final List<Player> players,
      required final List<PlayerTransition> transitions,
      required this.phase,
      this.currentKing})
      : _players = players,
        _transitions = transitions;

  factory _$GameImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameImplFromJson(json);

  final List<Player> _players;
  @override
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  final List<PlayerTransition> _transitions;
  @override
  List<PlayerTransition> get transitions {
    if (_transitions is EqualUnmodifiableListView) return _transitions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transitions);
  }

  @override
  final GamePhase phase;
  @override
  final Player? currentKing;

  @override
  String toString() {
    return 'Game(players: $players, transitions: $transitions, phase: $phase, currentKing: $currentKing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameImpl &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            const DeepCollectionEquality()
                .equals(other._transitions, _transitions) &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.currentKing, currentKing) ||
                other.currentKing == currentKing));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_players),
      const DeepCollectionEquality().hash(_transitions),
      phase,
      currentKing);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      __$$GameImplCopyWithImpl<_$GameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameImplToJson(
      this,
    );
  }
}

abstract class _Game implements Game {
  factory _Game(
      {required final List<Player> players,
      required final List<PlayerTransition> transitions,
      required final GamePhase phase,
      final Player? currentKing}) = _$GameImpl;

  factory _Game.fromJson(Map<String, dynamic> json) = _$GameImpl.fromJson;

  @override
  List<Player> get players;
  @override
  List<PlayerTransition> get transitions;
  @override
  GamePhase get phase;
  @override
  Player? get currentKing;
  @override
  @JsonKey(ignore: true)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
