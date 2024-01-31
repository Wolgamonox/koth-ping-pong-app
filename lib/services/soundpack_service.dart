import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';
import '../model/soundpack.dart';

part 'soundpack_service.g.dart';

const defaultSoundPack = SoundPack(
  name: 'debug',
  sounds: [
    Sound(type: SoundType.gameStart, path: "", duration: Duration(seconds: 1)),
    Sound(type: SoundType.gameEnd, path: "", duration: Duration(seconds: 1)),
    Sound(type: SoundType.pause, path: "", duration: Duration(seconds: 1)),
    Sound(type: SoundType.resume, path: "", duration: Duration(seconds: 1)),
    Sound(type: SoundType.newKing, path: "", duration: Duration(seconds: 1)),
    Sound(type: SoundType.overtime, path: "", duration: Duration(seconds: 1)),
  ],
);

@riverpod
class ActiveSoundPack extends _$ActiveSoundPack {
  @override
  SoundPack build() {
    // Todo: save last active sound pack using shared preference ? or just same storage as for sound packs
    return defaultSoundPack;
  }

  void setActiveSoundPack(SoundPack newSoundPack) {
    state = newSoundPack;
  }
}

@riverpod
Future<List<SoundPack>> soundPacks(SoundPacksRef ref) {
  return SoundPackManager().getSoundPacks();
}

class SoundPackManager {
  SoundPackManager();

  /// Gets the soundpacks storage directory
  Future<Directory> _getDirectory() async {
    final supportDirectoryPath = (await getApplicationSupportDirectory()).path;
    final soundPackDirectory = Directory("$supportDirectoryPath/soundpacks");

    // Create the directory if it does not exist yet
    soundPackDirectory.create();

    return soundPackDirectory;
  }

  Future<List<SoundPack>> getSoundPacks() async {
    return _getDirectory()
        .then((topDirectory) => topDirectory.list())
        .then((packsDirectories) => packsDirectories.asyncMap(
              (dir) => parseSoundPackDirectory(dir as Directory),
            ))
        .then((soundPacks) => soundPacks.toList());
  }

  Future<SoundPack> parseSoundPackDirectory(Directory directory) async {
    final name = directory.path.split("/").last;

    final sounds = await directory
        .list()
        .map((file) => Sound(
              type: SoundType.values.byName(
                file.path.split("/").last,
              ),
              path: file.path,
              duration: const Duration(seconds: 1),
            ))
        .toList();

    return SoundPack(name: name, sounds: sounds);
  }

  Future<void> addSoundPack(String path) async {
    final outputDir = (await _getDirectory());
    final archive = ZipDecoder().decodeBuffer(InputFileStream(path));

    // TODO add validity checks maybe

    extractArchiveToDisk(archive, outputDir.path);
    print("HELLO");
    print(await outputDir.list(recursive: true).toList());
  }
}
