import 'package:flutter/material.dart';
import 'package:koth_ping_pong_app/presentation/soundpack_page/soundpack_detail.dart';
import 'package:koth_ping_pong_app/presentation/soundpack_page/soundpack_list.dart';
import 'package:koth_ping_pong_app/services/soundpack_service.dart';

import 'presentation/homepage.dart';

const String title = 'Ping Pong Chrono';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.green,
      ),
      home: const Homepage(),
    );
  }
}
