import 'package:flutter/material.dart';

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
