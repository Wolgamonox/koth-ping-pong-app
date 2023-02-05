import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/player.dart';
import '../model/player_transition.dart';

const String hostName = "127.0.0.1:8000";

final kothServerServiceProvider =
    StateNotifierProvider<KothServerService, KothServer>(
  (ref) => KothServerService(),
);

@immutable
class KothServer {
  const KothServer(this.hostName);

  final String? hostName;

  Uri get uploadEndpointUrl => Uri.parse('http://$hostName/games/upload');

  Uri getPlayerUrl(String username) =>
      Uri.parse('http://$hostName/get_player?username=$username');


  KothServer copyWith({String? hostName}) {
    return KothServer(hostName ?? this.hostName);
  }
}

class KothServerService extends StateNotifier<KothServer> {
  KothServerService() : super(const KothServer(hostName));

  Future<Player?> getPlayer(String username) async {
    var response = await http.get(state.getPlayerUrl(username));
    if (response.statusCode == 200) {
      return Player.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<http.Response> sendToServer(
    List<Player> players,
    List<PlayerTransition> transitions,
  ) {
    return http.post(
      state.uploadEndpointUrl,
      //TODO add AUTH token
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataToJson(players, transitions)),
    );
  }
}
