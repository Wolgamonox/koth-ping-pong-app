import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koth_ping_pong_app/services/game_service.dart';
import 'package:koth_ping_pong_app/widgets/add_player_dialog.dart';
import 'model/game.dart';
import 'model/player.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameService = ref.read(gameServiceProvider.notifier);
    final game = ref.watch(gameServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: game.phase == GamePhase.idle
            ? [
                IconButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    // TODO add more information on why the request failed
                    // TODO Refactor for better return value as well using [AsyncValue]
                    Player? newPlayer = await openAddPlayerDialog(context);
                    if (newPlayer == null) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Player not found')),
                      );
                      return;
                    }

                    gameService.addPlayer(newPlayer);
                  },
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () => gameService.reset(alsoPlayers: true),
                  icon: const Icon(Icons.refresh),
                ),
              ]
            : null,
      ),
      body: Text(game.toString()),
      floatingActionButton: Visibility(
        visible:
            game.phase == GamePhase.playing || game.phase == GamePhase.paused,
        child: InkWell(
          onLongPress: gameService.reset,
          child: FloatingActionButton(
            onPressed: switch (game.phase) {
              GamePhase.playing => gameService.pause,
              GamePhase.paused => gameService.resume,
              _ => null,
            },
            child: switch (game.phase) {
              GamePhase.playing => const Icon(Icons.pause),
              GamePhase.paused => const Icon(Icons.play_arrow),
              _ => null,
            },
          ),
        ),
      ),
    );
  }
}
