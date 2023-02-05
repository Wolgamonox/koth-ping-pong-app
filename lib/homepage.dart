import 'dart:async';

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:koth_ping_pong_app/services/auth.dart';
import 'package:koth_ping_pong_app/widgets/qr_code_reader.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:audioplayers/audioplayers.dart';

import 'services/server_service.dart';
import 'widgets/add_player_dialog.dart';
import 'widgets/chrono_button.dart';

import 'model/player_transition.dart';
import 'model/player.dart';

const Duration defaultGameDuration = Duration(minutes: 10);
const String kingChangeSoundUrl =
    "https://lasonotheque.org/UPLOAD/mp3/1554.mp3";
const String gameStartSoundUrl = "https://lasonotheque.org/UPLOAD/mp3/2376.mp3";
const String overtimeStartSoundUrl =
    "https://lasonotheque.org/UPLOAD/mp3/0564.mp3";

enum GamePhase { idle, paused, playing, overtime }

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final List<PlayerTransition> transitions = [];
  final List<Player> players = [];

  Player? currentKing;
  GamePhase phase = GamePhase.idle;

  // Main game timer
  Duration gameDuration = defaultGameDuration;
  final CountdownController timerController = CountdownController();

  // To count each interval between transition
  final Stopwatch stopwatch = Stopwatch();

  List<Widget> _buildChronoButtons(List<Player> players) {
    return [
      for (var player in players)
        ChronoButton(
          playerFullName: player.fullName,
          color: player == currentKing ? Colors.amber : Colors.lightGreen,
          onPressed: _getButtonAction(player),
        ),
    ];
  }

  Function() _getButtonAction(Player player) {
    final kothServerService = ref.read(kothServerServiceProvider.notifier);

    switch (phase) {
      case GamePhase.idle:
        return () {
          var audioPlayer = AudioPlayer();

          audioPlayer.play(UrlSource(gameStartSoundUrl));
          Future.delayed(const Duration(seconds: 6))
              .then((value) => audioPlayer.stop());

          setState(() {
            phase = GamePhase.playing;
            currentKing = player;
            timerController.start();
            stopwatch.start();
          });
        };
      case GamePhase.playing:
        if (player != currentKing) {
          return () {
            AudioPlayer().play(UrlSource(kingChangeSoundUrl));

            setState(() {
              transitions.add(PlayerTransition(
                currentKing!,
                stopwatch.elapsed.inSeconds,
              ));

              // resets but continues running for next king
              stopwatch.reset();
              currentKing = player;
            });
          };
        } else {
          return () {};
        }
      case GamePhase.overtime:
        return () {
          setState(() {
            // add time of king before
            transitions.add(PlayerTransition(
              currentKing!,
              stopwatch.elapsed.inSeconds,
            ));

            if (player != currentKing) {
              transitions.add(PlayerTransition(player, 1));
            }

            kothServerService.sendToServer(
              players,
              transitions,
            );

            stopwatch.stop();
            stopwatch.reset();

            currentKing = null;
            transitions.clear();
            phase = GamePhase.idle;
          });
        };
      case GamePhase.paused:
        return () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: phase == GamePhase.idle
            ? [
                IconButton(
                  onPressed: () async {
                    var result = await showQRCodePage(context);
                    if (result != null) {
                      ref
                          .watch(kothAuthServiceProvider.notifier)
                          .setAuthToken(result);
                    }
                  },
                  icon: Icon(
                    ref.watch(kothAuthServiceProvider) ==
                            AuthenticationStatus.authenticated
                        ? Icons.wifi
                        : Icons.qr_code,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    Player? newPlayer = await openAddPlayerDialog(context);
                    if (newPlayer != null) {
                      setState(() {
                        players.add(newPlayer);
                      });
                    } else {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Player not found')),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      players.clear();
                      transitions.clear();
                      currentKing = null;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ]
            : null,
      ),
      floatingActionButton: Visibility(
        visible: phase == GamePhase.playing || phase == GamePhase.paused,
        child: InkWell(
          onLongPress: () {
            // Restart game
            setState(() {
              transitions.clear();
              currentKing = null;

              timerController.restart();
              timerController.pause();

              stopwatch.stop();
              stopwatch.reset();

              phase = GamePhase.idle;
            });
          },
          child: FloatingActionButton(
            onPressed: () {
              switch (phase) {
                case GamePhase.paused:
                  setState(() {
                    timerController.resume();
                    stopwatch.start();

                    phase = GamePhase.playing;
                  });
                  break;
                case GamePhase.playing:
                  setState(() {
                    timerController.pause();
                    stopwatch.stop();

                    phase = GamePhase.paused;
                  });
                  break;
                case GamePhase.overtime:
                case GamePhase.idle:
                  // Will not happen (button is hidden, cannot pause)
                  break;
              }
            },
            child: phase == GamePhase.playing
                ? const Icon(Icons.pause)
                : phase == GamePhase.paused
                    ? const Icon(Icons.play_arrow)
                    : null,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Countdown(
                  controller: timerController,
                  seconds: gameDuration.inSeconds,
                  build: (BuildContext context, double time) =>
                      phase == GamePhase.overtime
                          ? BlinkText(
                              'OVERTIME',
                              style: Theme.of(context).textTheme.displayMedium,
                              endColor: Colors.orange,
                            )
                          : Text(
                              '${twoDigits(time ~/ 60)}:${twoDigits((time % 60).toInt())}',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                  interval: const Duration(milliseconds: 100),
                  onFinished: () {
                    AudioPlayer().play(UrlSource(overtimeStartSoundUrl));
                    setState(() {
                      phase = GamePhase.overtime;
                      timerController.restart();
                      timerController.pause();
                    });
                  },
                ),
                ElevatedButton.icon(
                  onPressed: phase == GamePhase.idle
                      ? () async {
                          var chosenDuration = await showDurationPicker(
                            context: context,
                            initialTime: gameDuration,
                          );
                          setState(() {
                            if (chosenDuration != null) {
                              gameDuration = chosenDuration;
                            }
                          });
                        }
                      : null,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                // TODO remove future builder
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _buildChronoButtons(players),
                )),
          ),
        ],
      ),
    );
  }
}

String twoDigits(int n) => n.toString().padLeft(2, '0');
