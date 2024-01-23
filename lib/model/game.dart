import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:koth_ping_pong_app/model/player_transition.dart';

import 'player.dart';

part 'game.freezed.dart';

part 'game.g.dart';

enum GamePhase { idle, paused, playing, overtime }

@unfreezed
class Game with _$Game {
  Game._();
  factory Game([
    @Default([]) List<Player> players,
    @Default([]) List<PlayerTransition> transitions,
    @Default(GamePhase.idle) GamePhase phase,
    Player? currentKing,
  ]) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) =>
      _$GameFromJson(json);
}
