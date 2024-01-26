import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'soundpack.freezed.dart';

enum SoundType { gameStart, gameEnd, newKing, pause, resume, overtime }

@freezed
class Sound with _$Sound {
  const factory Sound({
    required SoundType type,
    required Duration duration,
}) = _Sound;
}

@freezed
class SoundPack with _$SoundPack {
  const factory SoundPack({
    required String name,
    required List<Sound> sounds,
  }) = _SoundPack;
}
