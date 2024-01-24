import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'player.freezed.dart';

part 'player.g.dart';

// TODO refactor server api to have same model as here, change full_name to fullName

@freezed
class Player with _$Player {
  const Player._();
  const factory Player({
    required int id,
    required String username,
    required String full_name,
  }) = _Player;

  factory Player.fromJson(Map<String, Object?> json)
  => _$PlayerFromJson(json);

  String get firstName => full_name.split(" ")[0];
  String get lastName => full_name.split(" ")[1];
}
