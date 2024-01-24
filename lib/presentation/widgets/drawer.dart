import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Tooltip(
            message: "Tap to change sound pack.",
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text("Debug"),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),
          ),
          Tooltip(
            message: "Tap to switch between light and dark theme.",
            child: ListTile(
              leading: switch (Theme.of(context).brightness) {
                Brightness.dark => const Icon(Icons.light_mode),
                Brightness.light => const Icon(Icons.dark_mode),
              },
              title: const Text("Change theme"),
              onTap: () {
                ref
                    .read(themeHandlerProvider.notifier)
                    .setBrightness(switch (Theme.of(context).brightness) {
                      Brightness.dark => Brightness.light,
                      Brightness.light => Brightness.dark,
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
