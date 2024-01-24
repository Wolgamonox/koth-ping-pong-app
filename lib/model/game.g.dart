// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameImpl _$$GameImplFromJson(Map<String, dynamic> json) => _$GameImpl(
      players: (json['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      transitions: (json['transitions'] as List<dynamic>?)
              ?.map((e) => PlayerTransition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      phase: $enumDecodeNullable(_$GamePhaseEnumMap, json['phase']) ??
          GamePhase.idle,
      currentKing: json['currentKing'] == null
          ? null
          : Player.fromJson(json['currentKing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GameImplToJson(_$GameImpl instance) =>
    <String, dynamic>{
      'players': instance.players,
      'transitions': instance.transitions,
      'phase': _$GamePhaseEnumMap[instance.phase]!,
      'currentKing': instance.currentKing,
    };

const _$GamePhaseEnumMap = {
  GamePhase.idle: 'idle',
  GamePhase.paused: 'paused',
  GamePhase.playing: 'playing',
  GamePhase.overtime: 'overtime',
};
