import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/soundpack.dart';

class SoundPackPage extends StatefulWidget {
  const SoundPackPage({super.key});

  @override
  State<SoundPackPage> createState() => _SoundPackPageState();
}

class _SoundPackPageState extends State<SoundPackPage> {
  final SearchController controller = SearchController();

  final soundPacks = List.generate(
    10,
    (index) => SoundPack(name: "sp$index", sounds: []),
  );

  SoundPack selectedSoundPack = const SoundPack(name: "debug", sounds: [
    Sound(type: SoundType.gameStart, duration: Duration(seconds: 2)),
    Sound(type: SoundType.gameEnd, duration: Duration(seconds: 4)),
  ]);

  List<SoundPack> search(String query) {
    if (query.isEmpty) {
      return [];
    }

    return soundPacks
        .where((sp) => sp.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    controller.text = selectedSoundPack.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sound packs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: SearchAnchor(
                  searchController: controller,
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (String query) {},
                      leading: const Icon(Icons.search),
                      hintText: "Search installed sound packs",
                      onSubmitted: (String query) {
                        SoundPack sp = soundPacks.firstWhere(
                          (sp) =>
                              sp.name.toLowerCase() ==
                              query.trim().toLowerCase(),
                        );
                        controller.closeView(sp.name);
                        setState(() {
                          selectedSoundPack = sp;
                        });
                      },
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return soundPacks.map(
                      (sp) => ListTile(
                        title: Text(sp.name),
                        onTap: () {
                          setState(() {
                            controller.closeView(sp.name);
                            selectedSoundPack = sp;
                          });
                        },
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Divider(),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Currently selected sound pack"),
                  Text(selectedSoundPack.name),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              flex: 6,
              child: SizedBox(
                height: 100.0,
                child: ListView(
                    children: selectedSoundPack.sounds
                        .map((s) => ListTile(
                              title: Text(s.type.name),
                              subtitle: Text(s.duration.toString()),
                              trailing: const Icon(Icons.play_arrow),
                              onTap: () {},
                            ))
                        .toList()),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Add a new sound pack.",
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
