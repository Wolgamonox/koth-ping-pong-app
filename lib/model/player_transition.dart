import 'package:freezed_annotation/freezed_annotation.dart';
import 'player.dart';

part 'player_transition.freezed.dart';

part 'player_transition.g.dart';

@freezed
class PlayerTransition with _$PlayerTransition {
  const PlayerTransition._();

  const factory PlayerTransition({
    required Player player,
    required int duration, // in seconds
  }) = _PlayerTransition;

  factory PlayerTransition.fromJson(Map<String, Object?> json) =>
      _$PlayerTransitionFromJson(json);
}

// TODO use the game serialization instead
Map<String, dynamic> dataToJson(
    List<Player> players, List<PlayerTransition> transitions) {
  Map<String, dynamic> json = {
    'players': [for (var player in players) player.id],
    'transitions': [
      for (var transition in transitions)
        {"player": transition.player.id, "duration": transition.duration}
    ],
  };

  return json;
}
