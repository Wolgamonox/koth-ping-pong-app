import 'package:flutter/material.dart';

class SoundPackPage extends StatelessWidget {
  const SoundPackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sound packs"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
            );
          }, suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(title: Text(item), onTap: null);
            });
          }),
        ],
      ),
    );
  }
}
