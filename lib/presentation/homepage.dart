import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koth_ping_pong_app/presentation/widgets/drawer.dart';

import '../services/game_service.dart';

import '../model/game.dart';
import '../model/player.dart';

import 'widgets/add_player_dialog.dart';
import 'widgets/chrono_button.dart';
import 'widgets/countdown.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameService = ref.read(gameServiceProvider.notifier);
    final game = ref.watch(gameServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("King of the Hill"),
        actions: game.phase == GamePhase.idle
            ? [
                Tooltip(
                  message: "Add a new player.",
                  child: IconButton(
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
                ),
                Tooltip(
                  message: "Remove all players.",
                  child: IconButton(
                    onPressed: () => gameService.reset(alsoPlayers: true),
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          const Expanded(flex: 2, child: Center(child: CountDownWidget())),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: game.players
                    .map(
                      (player) => ChronoButton(
                        name: player.firstName,
                        isKing: player == game.currentKing,
                        onPressed: switch (game.phase) {
                          GamePhase.idle => () =>
                              gameService.startWithKing(player),
                          GamePhase.playing => () =>
                              gameService.newKing(player),
                          GamePhase.paused => null,
                          GamePhase.overtime => () =>
                              gameService.endWithLastKing(player),
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible:
            game.phase == GamePhase.playing || game.phase == GamePhase.paused,
        child: Tooltip(
          message: "Long press to reset the game.",
          child: InkWell(
            onLongPress: gameService.reset,
            child: switch (game.phase) {
              GamePhase.playing => FloatingActionButton(
                  onPressed: gameService.pause,
                  child: const Icon(Icons.pause),
                ),
              GamePhase.paused => FloatingActionButton(
                  onPressed: gameService.resume,
                  child: const Icon(Icons.play_arrow),
                ),
              _ => null,
            },
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
