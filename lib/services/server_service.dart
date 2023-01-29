import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/player_transition.dart';

final kothServerServiceProvider =
    StateNotifierProvider<KothServerService, KothServer>(
  (ref) => KothServerService(),
);

@immutable
class KothServer {
  const KothServer(this.hostName, this.connected);

  final String? hostName;
  final bool connected;

  Uri get pingEndpointUrl => Uri.parse('http://$hostName/ping');

  Uri get uploadEndpointUrl => Uri.parse('http://$hostName/upload');

  KothServer copyWith({String? hostName, bool? connected}) {
    return KothServer(hostName ?? this.hostName, connected ?? this.connected);
  }
}

class KothServerService extends StateNotifier<KothServer> {
  KothServerService() : super(const KothServer(null, false));

  void setHostName(String hostName) {
    state = state.copyWith(hostName: hostName);
  }

  Future<void> checkConnection() async {
    if (state.hostName != null) {
      await http
          .get(state.pingEndpointUrl)
          .timeout(const Duration(seconds: 10))
          .then(
        (value) {
          state = state.copyWith(connected: true);
        },
        onError: (error, stacktrace) {
          state = state.copyWith(connected: false);
        },
      );
    }
  }

  Future<http.Response> sendToServer(
    List<String> players,
    List<PlayerTransition> transitions,
  ) {
    return http.post(
      Uri.parse('http://${state.hostName}/upload'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataToJson(players, transitions)),
    );
  }
}
