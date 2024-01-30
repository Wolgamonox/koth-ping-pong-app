import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koth_ping_pong_app/services/soundpack_service.dart';
import 'package:koth_ping_pong_app/utils.dart';

import '../../model/soundpack.dart';

class SoundPackDetailPage extends ConsumerWidget {
  const SoundPackDetailPage({super.key, required this.soundPack});

  final SoundPack soundPack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(soundPack.name.capitalize()),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: soundPack == ref.watch(activeSoundPackProvider)
                  ? FilledButton.tonalIcon(
                      onPressed: null,
                      icon: const Icon(Icons.check),
                      label: const Text("Active"),
                    )
                  : FilledButton.tonal(
                      onPressed: () {
                        ref
                            .read(activeSoundPackProvider.notifier)
                            .setActiveSoundPack(soundPack);

                        Navigator.of(context).pop();
                      },
                      child: const Text("Activate"),
                    ),
            )
          ],
        ),
        body: ListView(
          children: soundPack.sounds
              .map((sound) => ListTile(
                    title: Text(sound.type.name),
                    subtitle: Text(sound.duration.toString()),
                    trailing: const Icon(Icons.play_arrow),
                    // TODO add sound play
                    onTap: () {},
                  ))
              .toList(),
        ));
  }
}
