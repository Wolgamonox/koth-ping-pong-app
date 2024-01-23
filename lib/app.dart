import 'package:flutter/material.dart';

import 'homepage.dart';

const String title = 'Ping Pong Chrono';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: title,
      home: Homepage(title: title),
    );
  }
}