import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/theme.dart';

import 'presentation/homepage.dart';

const String title = 'Ping Pong Chrono';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: title,
      theme: ref.watch(themeHandlerProvider),
      home: const Homepage(),
    );
  }
}
