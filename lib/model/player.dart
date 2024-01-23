import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'player.freezed.dart';

part 'player.g.dart';

@freezed
class Player with _$Player {
  const Player._();
  const factory Player({
    required int id,
    required String username,
    required String fullName,
  }) = _Player;

  factory Player.fromJson(Map<String, Object?> json)
  => _$PlayerFromJson(json);

  String get firstName => fullName.split(" ")[0];
  String get lastName => fullName.split(" ")[1];
}
