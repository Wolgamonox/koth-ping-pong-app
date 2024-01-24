import 'package:audioplayers/audioplayers.dart';
import 'package:koth_ping_pong_app/model/player_transition.dart';
import 'package:koth_ping_pong_app/services/server_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../model/game.dart';
import '../model/player.dart';

part 'game_service.g.dart';

class GameError extends StateError {
  GameError(super.message);

  @override
  String toString() => "GameError: $message";
}

// TODO refactor to include sound pack functionality
@riverpod
AudioPlayer audioPlayer(AudioPlayerRef ref) {
  return AudioPlayer();
}

@riverpod
Stopwatch stopwatch(StopwatchRef ref) {
  return Stopwatch();
}

@riverpod
CountdownController countdownController(CountdownControllerRef ref) {
  return CountdownController();
}

@riverpod
class GameService extends _$GameService {
  @override
  Game build() => Game.empty();

  void addPlayer(Player player) {
    state = state.copyWith(players: [...state.players, player]);
  }

  void removePlayer(Player playerToRemove) {
    final players =
        state.players.where((player) => player != playerToRemove).toList();
    state = state.copyWith(players: players);
  }

  void addTransition(PlayerTransition transition) {
    state = state.copyWith(transitions: [...state.transitions, transition]);
  }

  void startWithKing(Player firstKing) {
    if (state.phase != GamePhase.idle) {
      throw GameError("Cannot start game when not in idle phase");
    }

    state = state.copyWith(phase: GamePhase.playing, currentKing: firstKing);
    ref.read(stopwatchProvider).start();
    ref.read(countdownControllerProvider).start();
    ref.read(audioPlayerProvider).play(AssetSource('sounds/game_start.mp3'));
  }

  void pause() {
    if (state.phase != GamePhase.playing) {
      throw GameError("Cannot pause game when not in playing phase");
    }
    state = state.copyWith(phase: GamePhase.paused);
    ref.read(stopwatchProvider).stop();
    ref.read(countdownControllerProvider).pause();
    ref.read(audioPlayerProvider).play(AssetSource('sounds/pause.mp3'));
  }

  void resume() {
    if (state.phase != GamePhase.paused) {
      throw GameError("Cannot resume game when not in paused phase");
    }
    state = state.copyWith(phase: GamePhase.playing);
    ref.read(stopwatchProvider).start();
    ref.read(countdownControllerProvider).resume();
    ref.read(audioPlayerProvider).play(AssetSource('sounds/resume.mp3'));
  }

  void overtime() {
    if (state.phase != GamePhase.playing) {
      throw GameError("Cannot start overtime game when not in playing phase");
    }

    state = state.copyWith(phase: GamePhase.overtime);
    ref.read(audioPlayerProvider).play(AssetSource('sounds/overtime.mp3'));
  }

  void endWithLastKing(Player lastKing) {
    if (state.phase != GamePhase.overtime) {
      throw GameError("Cannot end game when not in overtime phase");
    }

    // Game is finished, get last player transition
    addTransition(PlayerTransition(
      player: state.currentKing!,
      duration: ref.read(stopwatchProvider).elapsed.inSeconds,
    ));

    if (lastKing != state.currentKing) {
      addTransition(PlayerTransition(player: lastKing, duration: 1));
    }

    ref.read(audioPlayerProvider).play(AssetSource('sounds/game_end.mp3'));

    // send it to the server
    ref.read(kothServerServiceProvider.notifier).sendToServer(
          state.players,
          state.transitions,
        );

    // TODO: further improvement keep last king highlighted (maybe)
    // clean up for next game
    reset();
  }

  void newKing(Player newKing) {
    if (state.currentKing == null) {
      throw GameError("Current king is null");
    }

    if (state.currentKing == newKing) {
      // do nothing
      return;
    }

    ref.read(audioPlayerProvider).play(AssetSource('sounds/king_change.mp3'));

    // Save the last reign in a player transition
    addTransition(PlayerTransition(
      player: state.currentKing!,
      duration: ref.watch(stopwatchProvider).elapsed.inSeconds,
    ));

    ref.read(stopwatchProvider).reset();
    state = state.copyWith(currentKing: newKing);
  }

  void reset({bool alsoPlayers = false}) {
    ref.read(stopwatchProvider).stop();
    ref.read(stopwatchProvider).reset();
    ref.read(countdownControllerProvider).restart();
    ref.read(countdownControllerProvider).pause();

    if (alsoPlayers) {
      state = Game.empty();
    } else {
      state = Game.empty(withPlayers: state.players);
    }
  }
}
