import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:koth_ping_pong_app/presentation/soundpack_page/soundpack_detail.dart';
import 'package:koth_ping_pong_app/utils.dart';
import '../../model/soundpack.dart';
import '../../services/soundpack_service.dart';

class SoundPackListPage extends ConsumerStatefulWidget {
  const SoundPackListPage({super.key});

  @override
  ConsumerState<SoundPackListPage> createState() => _SoundPackListPageState();
}

class _SoundPackListPageState extends ConsumerState<SoundPackListPage> {
  final controller = TextEditingController();

  // List<SoundPack> search(String query) {
  //   if (query.isEmpty) {
  //     return [];
  //   }
  //
  //   return soundPacks
  //       .where((sp) => sp.name.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    final activeSoundPack = ref.watch(activeSoundPackProvider);
    final soundPacks = ref.watch(soundPacksProvider);

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
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  controller: controller,
                  // TODO implement search of soundpacks
                  onTap: () {},
                  onChanged: (String query) {},
                  onSubmitted: (String query) {},
                  leading: const Icon(Icons.search),
                  hintText: "Search installed sound packs",
                ),
              ),
            ),
            const Divider(),
            Expanded(
              flex: 8,
              child: ListView(
                children: [
                  ListTile(
                    trailing: const Icon(Icons.music_note),
                    title: Text(
                      activeSoundPack.name.capitalize(),
                    ),
                    selected: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SoundPackDetailPage(soundPack: activeSoundPack),
                        ),
                      );
                    },
                  ),
                  ...soundPacks.when(
                      data: (data) =>
                          data.where((sp) => sp != activeSoundPack).map(
                                (sp) => ListTile(
                                  title: Text(sp.name.capitalize()),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SoundPackDetailPage(soundPack: sp),
                                      ),
                                    );
                                  },
                                  // TODO: add deletion + confirmation dialog
                                  onLongPress: null,
                                ),
                              ),
                      error: (err, st) => [],
                      loading: () => [const CircularProgressIndicator()])
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Add a new sound pack.",
        child: FloatingActionButton(
          // TODO add a filepicker soundpack
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              setState(() async {
                await SoundPackManager()
                    .addSoundPack(result.files.single.path!);
              });
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
