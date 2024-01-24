import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:koth_ping_pong_app/model/player_transition.dart';

import 'player.dart';

part 'game.freezed.dart';

part 'game.g.dart';

enum GamePhase { idle, paused, playing, overtime }

@freezed
class Game with _$Game {
  factory Game({
    required List<Player> players,
    required List<PlayerTransition> transitions,
    required GamePhase phase,
    Player? currentKing,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  factory Game.empty({List<Player>? withPlayers}) => Game(
        players: withPlayers ?? [],
        transitions: [],
        phase: GamePhase.idle,
      );
}
