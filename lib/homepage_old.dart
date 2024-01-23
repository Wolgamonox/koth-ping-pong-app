import 'package:duration_picker/duration_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
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

const LinearGradient portraitGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: <Color>[Color(0xfeeef2f3), Color(0xff8e9eab)],
);

enum GamePhase { idle, paused, playing, overtime }

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key, required this.title});

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

  final AudioPlayer audioPlayer = AudioPlayer();

  List<Widget> _buildChronoButtons(List<Player> players) {
    return [
      for (var player in players)
        ChronoButton(
          playerFullName: player.firstName,
          color: player == currentKing ? Colors.amber : Colors.lightGreen,
          onPressed: _getButtonAction(player),
        ),
    ];
  }

  Function()? _getButtonAction(Player player) {
    final kothServerService = ref.read(kothServerServiceProvider.notifier);

    switch (phase) {
      case GamePhase.idle:
        return () {
          audioPlayer.play(AssetSource('sounds/game_start.mp3'));

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
            audioPlayer.play(AssetSource('sounds/king_change.mp3'));

            setState(() {
              transitions.add(PlayerTransition(
                player: currentKing!,
                duration: stopwatch.elapsed.inSeconds,
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
          audioPlayer.play(AssetSource('sounds/game_stop.mp3'));

          setState(() {
            // add time of king before
            transitions.add(PlayerTransition(
              player: currentKing!,
              duration: stopwatch.elapsed.inSeconds,
            ));

            if (player != currentKing) {
              transitions.add(PlayerTransition(player:player,duration: 1));
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
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        elevation: 2.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: portraitGradient,
          ),
        ),
        actions: phase == GamePhase.idle
            ? [
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
                  icon: const Icon(Icons.add, color: Colors.black),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      players.clear();
                      transitions.clear();
                      currentKing = null;
                    });
                  },
                  icon: const Icon(Icons.refresh, color: Colors.black),
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
            backgroundColor: const Color(0xff0a2e36),
            onPressed: () {
              switch (phase) {
                case GamePhase.paused:
                  audioPlayer.play(AssetSource('sounds/resume.mp3'));
                  setState(() {
                    timerController.resume();
                    stopwatch.start();

                    phase = GamePhase.playing;
                  });
                  break;
                case GamePhase.playing:
                  audioPlayer.play(AssetSource('sounds/pause.mp3'));
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Countdown(
                  controller: timerController,
                  seconds: gameDuration.inSeconds,
                  build: (BuildContext context, double time) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
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
                      child: phase == GamePhase.overtime
                          ? BlinkText(
                              'OVERTIME',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: Colors.black87),
                              endColor: Colors.orange,
                            )
                          : Text(
                              '${twoDigits(time ~/ 60)}:${twoDigits((time % 60).toInt())}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: Colors.black87),
                            ),
                    ),
                  ),
                  interval: const Duration(milliseconds: 100),
                  onFinished: () {
                    audioPlayer.play(AssetSource('sounds/overtime.mp3'));
                    setState(() {
                      phase = GamePhase.overtime;
                      timerController.restart();
                      timerController.pause();
                    });
                  },
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
