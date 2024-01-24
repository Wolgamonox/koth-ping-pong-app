import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/player.dart';
import '../model/player_transition.dart';

const String hostName = "wolgamonox.pythonanywhere.com";

// TODO refactor for riverpod codegen


final kothServerServiceProvider =
    StateNotifierProvider<KothServerService, KothServer>(
  (ref) => KothServerService(),
);

@immutable
class KothServer {
  const KothServer();

// Useless for now
// might be needed when we add token identification
}

class KothServerService extends StateNotifier<KothServer> {
  KothServerService() : super(const KothServer());

  Future<Player?> getPlayer(String username) async {
    var response = await http.get(Uri.https(
      hostName,
      '/get-player',
      {'username': username},
    ));
    if (response.statusCode == 200) {
      // TODO refactor server api to have same model as here, change full_name to fullName
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
      Uri.https(hostName, '/games/upload'),
      //TODO add AUTH token
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataToJson(players, transitions)),
    );
  }
}
