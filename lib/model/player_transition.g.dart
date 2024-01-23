// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_transition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerTransitionImpl _$$PlayerTransitionImplFromJson(
        Map<String, dynamic> json) =>
    _$PlayerTransitionImpl(
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      duration: json['duration'] as int,
    );

Map<String, dynamic> _$$PlayerTransitionImplToJson(
        _$PlayerTransitionImpl instance) =>
    <String, dynamic>{
      'player': instance.player,
      'duration': instance.duration,
    };
