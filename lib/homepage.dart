import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:koth_ping_pong_app/qr_code_reader.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:audioplayers/audioplayers.dart';

import 'add_player_dialog.dart';
import 'chrono_button.dart';

const Duration gameDuration = Duration(minutes: 5);

class PlayerTransition {
  final String name;
  final int interval;

  PlayerTransition(this.name, this.interval);

  @override
  String toString() {
    return '$name:$interval';
  }
}

Map<String, dynamic> transitionsToJson(List<PlayerTransition> transitions) {
  Map<String, dynamic> json = {
    'transitions': [
      for (var transition in transitions)
        {transition.name: transition.interval}
    ],
  };
  
  return json;
}

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

  final CountdownController timerController = CountdownController();
  final Stopwatch stopwatch = Stopwatch();

  String? serverHost;

  List<Widget> _buildChronoButtons(List<String> players) {
    return [
      for (var player in players)
        ChronoButton(
          player: player,
          color: player == currentKing ? Colors.amber : Colors.deepPurpleAccent,
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
          print('transitions: $transitions');
        };
      case GamePhase.paused:
        return () {};
      case GamePhase.playing:
        if (player != currentKing) {
          return () {
            print('$player is now king');
            setState(() {
              transitions.add(
                  PlayerTransition(currentKing, stopwatch.elapsed.inSeconds));

              // resets but continues running for next king
              stopwatch.reset();
              currentKing = player;
            });
            print('transitions: $transitions');


            print('transitions (json): ${transitionsToJson(transitions)}');
          };
        } else {
          return () {};
        }
      case GamePhase.overtime:
        return () {
          print('$player is last king');

          setState(() {
            // add time of king before
            transitions.add(
                PlayerTransition(currentKing, stopwatch.elapsed.inSeconds));

            if (player != currentKing) {
              transitions.add(PlayerTransition(player, 1));
            }

            stopwatch.stop();
            stopwatch.reset();

            currentKing = '';
            phase = GamePhase.idle;
          });

          if (serverHost != null) {
            sendToServer(transitions, serverHost!).then((value) => print(value.statusCode));
          } else {
            print('No server connected');
          }
        };
    }
  }

  Future<String?> _openAddPlayerDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return const AddPlayerDialog();
      },
    );
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
                    setState(() {
                      serverHost = result;
                    });
                  },
                  icon: Icon(Icons.qr_code, color: serverHost != null ? Colors.green : Colors.red,),
                ),
                IconButton(
                  onPressed: () async {
                    String? result = await _openAddPlayerDialog(context);
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
            flex: 1,
            child: Countdown(
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
                // play sound sncf
                // https://lasonotheque.org/UPLOAD/mp3/0564.mp3

                AudioPlayer().play(UrlSource('https://lasonotheque.org/UPLOAD/mp3/0564.mp3'));

                setState(() {
                  print('Timer finished');
                  phase = GamePhase.overtime;
                  timerController.restart();
                  timerController.pause();
                });
              },
            ),
          ),
          Expanded(
            flex: 9,
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

Future<http.Response> sendToServer(List<PlayerTransition> transitions, String hostName) {
  print('HTTP REQUEST URL : http://$hostName/upload');
  return http.post(
    Uri.parse('http://$hostName/upload'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(transitionsToJson(transitions)),
  );
}

String twoDigits(int n) => n.toString().padLeft(2, '0');


