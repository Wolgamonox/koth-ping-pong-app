import 'player.dart';

class PlayerTransition {
  final Player player;
  final int duration;

  PlayerTransition(this.player, this.duration);

  @override
  String toString() {
    return '$player:$duration';
  }
}

Map<String, dynamic> dataToJson(List<Player> players, List<PlayerTransition> transitions) {
  Map<String, dynamic> json = {
    'players': [
      for (var player in players)
        player.id
    ],
    'transitions': [
      for (var transition in transitions) {
        "player": transition.player.id,
        "duration": transition.duration
      }
    ],
  };

  return json;
}