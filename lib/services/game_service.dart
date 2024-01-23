// Handles the game logic

import 'package:flutter/cupertino.dart';
import 'package:koth_ping_pong_app/model/player_transition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/game.dart';
import '../model/player.dart';

part 'game_service.g.dart';

class GameError extends StateError {
  GameError(super.message);

  @override
  String toString() => "GameError: $message";
}

@riverpod
Stopwatch stopwatch(StopwatchRef ref) {
  return Stopwatch();
}

@riverpod
class GameService extends _$GameService {
  @override
  Game build() => Game();

  void addPlayer(Player player) {
    state.players.add(player);
  }

  void removePlayer(Player player) {
    if (state.players.contains(player)) {
      state.players.remove(player);
    }
  }

  void start() {
    if (state.phase != GamePhase.idle) {
      throw GameError("Cannot start game when not in idle phase");
    }

    state.phase = GamePhase.playing;
    ref.read(stopwatchProvider).start();
  }

  void pause() {
    if (state.phase != GamePhase.playing) {
      throw GameError("Cannot pause game when not in playing phase");
    }
    state.phase = GamePhase.paused;
    ref.read(stopwatchProvider).stop();
  }

  void resume() {
    if (state.phase != GamePhase.paused) {
      throw GameError("Cannot resume game when not in paused phase");
    }
    state.phase = GamePhase.playing;
    ref.read(stopwatchProvider).start();
  }

  void overtime() {
    if (state.phase != GamePhase.playing) {
      throw GameError("Cannot start overtime game when not in playing phase");
    }
    state.phase = GamePhase.overtime;
  }

  void endWithLastKing(Player lastKing) {
    if (state.phase != GamePhase.overtime) {
      throw GameError("Cannot end game when not in overtime phase");
    }

    state.phase = GamePhase.idle;
    final stopwatch = ref.read(stopwatchProvider);
    stopwatch.stop();

    // Game is finished, get last player transition
    state.transitions.add(PlayerTransition(
      player: state.currentKing!,
      duration: stopwatch.elapsed.inSeconds,
    ));

    if (lastKing != state.currentKing) {
      state.transitions.add(PlayerTransition(player: lastKing, duration: 1));
    }

    // send it to the server
    // TODO


    // clean up for next game (keep players but reset transitions)
    stopwatch.reset();
    state.transitions.clear();

    // TODO: further improvement keep last king highlighted
    state.currentKing = null;
  }

  void newKing(Player newKing,) {
    if (state.currentKing == null) {
      throw GameError("Current king is null");
    }

    // Save last kings reign in a player transition
    state.transitions.add(PlayerTransition(
      player: state.currentKing!,
      duration: ref.read(stopwatchProvider).elapsed.inSeconds,
    ));

  }
}
