import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final int id;
  final String username;
  final String fullName;

  const Player(this.id, this.username, this.fullName);

  Player.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        fullName = json['full_name'];

  @override
  String toString() {
    return username;
  }

  @override
  List<Object?> get props => [id, username, fullName];
}
