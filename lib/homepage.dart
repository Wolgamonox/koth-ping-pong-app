import 'dart:async';
import 'dart:convert';
import 'package:duration_picker/duration_picker.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:koth_ping_pong_app/widgets/qr_code_reader.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:audioplayers/audioplayers.dart';

import 'widgets/add_player_dialog.dart';
import 'widgets/chrono_button.dart';

import 'model/player_transition.dart';

const Duration defaultGameDuration = Duration(minutes: 5);
const String kingChangeSoundUrl =
    "https://lasonotheque.org/UPLOAD/mp3/1554.mp3";
const String minuteSoundUrl = "https://lasonotheque.org/UPLOAD/mp3/1830.mp3";
const String overtimeStartSoundUrl =
    "https://lasonotheque.org/UPLOAD/mp3/0564.mp3";

// TODO implement pause
enum GamePhase { idle, paused, playing, overtime }

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<PlayerTransition> transitions = [];
  final List<String> players = [];

  String currentKing = '';
  GamePhase phase = GamePhase.idle;

  // Main game timer
  Duration gameDuration = defaultGameDuration;
  final CountdownController timerController = CountdownController();

  // To count each interval between transition
  final Stopwatch stopwatch = Stopwatch();

  // For sound playing purposes
  Timer? minuteTimer;

  // Name of the server, format: <ip-address>:<port>
  String? serverHost;

  List<Widget> _buildChronoButtons(List<String> players) {
    return [
      for (var player in players)
        ChronoButton(
          player: player,
          color: player == currentKing ? Colors.amber : Colors.lightGreen,
          onPressed: _getButtonAction(player),
        ),
    ];
  }

  Function() _getButtonAction(String player) {
    switch (phase) {
      case GamePhase.idle:
        return () {
          print('Start timer with $player as king');

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
            print('$player is now king');

            AudioPlayer().play(UrlSource(kingChangeSoundUrl));

            setState(() {
              transitions.add(PlayerTransition(
                currentKing,
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
          print('$player is last king');

          setState(() {
            // add time of king before
            transitions.add(PlayerTransition(
              currentKing,
              stopwatch.elapsed.inSeconds,
            ));

            if (player != currentKing) {
              transitions.add(PlayerTransition(player, 1));
            }

            if (serverHost != null) {
              sendToServer(transitions, serverHost!);
            } else {
              print('No server connected');
            }

            stopwatch.stop();
            stopwatch.reset();

            currentKing = '';
            transitions.clear();
            phase = GamePhase.idle;
          });
        };
      case GamePhase.paused:
        return () {};
    }
  }

  @override
  void initState() {
    super.initState();

    // add a timer that makes a sound every minute
    timerController.setOnStart(() {
      minuteTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        AudioPlayer().play(UrlSource(minuteSoundUrl));
      });
    });

    timerController.setOnResume(() {
      minuteTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        AudioPlayer().play(UrlSource(minuteSoundUrl));
      });
    });

    timerController.setOnPause(() {
      minuteTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ping Pong Chrono'),
        actions: phase == GamePhase.idle || phase == GamePhase.paused
            ? [
                IconButton(
                  onPressed: () async {
                    var result = await showQRCodePage(context);
                    // TODO: Save server host to shared preferences.
                    setState(() {
                      serverHost = result;
                    });
                  },
                  icon: Icon(
                    Icons.qr_code,
                    color: serverHost != null ? Colors.green : Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    String? result = await openAddPlayerDialog(context);
                    if (result != null) {
                      setState(() {
                        players.add(result);
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      players.clear();
                      transitions.clear();
                      currentKing = '';
                    });
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ]
            : null,
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
                  onPressed: () async {
                    var chosenDuration = await showDurationPicker(
                      context: context,
                      initialTime: gameDuration,
                    );
                    setState(() {
                      if (chosenDuration != null) {
                        gameDuration = chosenDuration;
                      }
                    });
                  },
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
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: _buildChronoButtons(players),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<http.Response> sendToServer(
    List<PlayerTransition> transitions, String hostName) {
  return http.post(
    Uri.parse('http://$hostName/upload'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(transitionsToJson(transitions)),
  );
}

String twoDigits(int n) => n.toString().padLeft(2, '0');
