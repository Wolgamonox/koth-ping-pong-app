import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'homepage.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

const String title = 'Ping Pong Chrono';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: Homepage(title: title),
    );
  }
}
