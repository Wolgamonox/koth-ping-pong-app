import 'package:audioplayers/audioplayers.dart';
import 'package:koth_ping_pong_app/model/player_transition.dart';
import 'package:koth_ping_pong_app/services/server_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
class GameService extends _$GameService {
  @override
  Game build() => Game();

  void addPlayer(Player player) {
    state.players = [...state.players, player];
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

    state = state.copyWith(phase: GamePhase.playing);
    ref.read(stopwatchProvider).start();
    ref.read(audioPlayerProvider).play(AssetSource('sounds/game_start.mp3'));
  }

  void pause() {
    if (state.phase != GamePhase.playing) {
      throw GameError("Cannot pause game when not in playing phase");
    }
    state = state.copyWith(phase: GamePhase.paused);
    ref.read(stopwatchProvider).stop();
    ref.read(audioPlayerProvider).play(AssetSource('sounds/pause.mp3'));
  }

  void resume() {
    if (state.phase != GamePhase.paused) {
      throw GameError("Cannot resume game when not in paused phase");
    }
    state = state.copyWith(phase: GamePhase.playing);
    ref.read(stopwatchProvider).start();
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

    state = state.copyWith(phase: GamePhase.idle);
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

    ref.read(audioPlayerProvider).play(AssetSource('sounds/game_end.mp3'));

    // send it to the server
    ref.read(kothServerServiceProvider.notifier).sendToServer(
          state.players,
          state.transitions,
        );

    // clean up for next game
    reset();

    // TODO: further improvement keep last king highlighted
    state = state.copyWith(currentKing: null);
  }

  void newKing(Player newKing) {
    if (state.currentKing == null) {
      throw GameError("Current king is null");
    }

    ref.read(audioPlayerProvider).play(AssetSource('sounds/king_change.mp3'));

    // Save last kings reign in a player transition
    state.transitions.add(PlayerTransition(
      player: state.currentKing!,
      duration: ref.read(stopwatchProvider).elapsed.inSeconds,
    ));
  }

  void reset({bool alsoPlayers = false}) {
    if (alsoPlayers) {
      state = Game();
    } else {
      state = Game(players: state.players);
    }
  }
}
