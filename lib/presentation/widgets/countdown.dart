import 'package:blinking_text/blinking_text.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timer_count_down/timer_count_down.dart';

import '../../model/game.dart';
import '../../services/game_service.dart';

const Duration defaultGameDuration = Duration(seconds: 20);

class CountDownWidget extends ConsumerStatefulWidget {
  const CountDownWidget({super.key});

  @override
  ConsumerState<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends ConsumerState<CountDownWidget> {
  Duration gameDuration = defaultGameDuration;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameServiceProvider);
    final controller = ref.watch(countdownControllerProvider);

    return Countdown(
      controller: controller,
      seconds: gameDuration.inSeconds,
      build: (_, double time) => ElevatedButton(
        onPressed: game.phase == GamePhase.idle
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
        child: game.phase == GamePhase.overtime
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
      interval: const Duration(milliseconds: 100),
      onFinished: ref.read(gameServiceProvider.notifier).overtime,
    );
  }
}

String twoDigits(int n) => n.toString().padLeft(2, '0');
