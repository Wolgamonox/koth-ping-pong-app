import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/soundpack.dart';

part 'soundpack_service.g.dart';

const defaultSoundPack = SoundPack(
  name: 'debug',
  sounds: [
    Sound(type: SoundType.gameStart, duration: Duration(seconds: 1)),
    Sound(type: SoundType.gameEnd, duration: Duration(seconds: 1)),
    Sound(type: SoundType.pause, duration: Duration(seconds: 1)),
    Sound(type: SoundType.resume, duration: Duration(seconds: 1)),
    Sound(type: SoundType.newKing, duration: Duration(seconds: 1)),
    Sound(type: SoundType.overtime, duration: Duration(seconds: 1)),
  ],
);

// Todo: save last active sound pack using shared preference ? or just same storage as for sound packs

@riverpod
class ActiveSoundPack extends _$ActiveSoundPack {
  @override
  SoundPack build() {
    return defaultSoundPack;
  }

  void setActiveSoundPack(SoundPack newSoundPack) {
    state = newSoundPack;
  }
}
