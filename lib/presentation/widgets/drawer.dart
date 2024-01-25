import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              title: const Text("Sound pack"),
              subtitle: const Text("debug"),
              trailing: const Icon(Icons.edit),
              onTap: () {},
            ),
          ),
          const Tooltip(
            message: "Tap to select a game preset.",
            child: ListTile(
              leading: Icon(Icons.save),
              title: Text("Presets"),
              subtitle: Text(
                "Not Implemented",
                style: TextStyle(color: Colors.red),
              ),
              trailing: Icon(Icons.edit),
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }
}
