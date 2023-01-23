import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:blinking_text/blinking_text.dart';

import 'add_player_dialog.dart';
import 'chrono_button.dart';

class PlayerTransition {
  final String name;
  final int interval;

  PlayerTransition(this.name, this.interval);
  @override
  String toString() {
    return '$name:$interval';
  }
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
              transitions.add(
                  PlayerTransition(player, 1));
            }

            stopwatch.stop();
            stopwatch.reset();

            phase = GamePhase.idle;
          });
          print('transitions: $transitions');
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
                // TODO disable actions while playing
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
              seconds: const Duration(seconds: 30).inSeconds,
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
                setState(() {
                  print('Timer finished');
                  phase = GamePhase.overtime;
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

String twoDigits(int n) => n.toString().padLeft(2, '0');
