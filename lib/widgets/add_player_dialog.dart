import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/player.dart';
import '../services/server_service.dart';

Future<Player?> openAddPlayerDialog(BuildContext context) async {
  return await showDialog<Player>(
    context: context,
    builder: (context) {
      return const AddPlayerDialog();
    },
  );
}

class AddPlayerDialog extends ConsumerStatefulWidget {
  const AddPlayerDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends ConsumerState<AddPlayerDialog> {
  TextEditingController controller = TextEditingController();

  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final kothServerService = ref.read(kothServerServiceProvider.notifier);

    return AlertDialog(
      title: const Text('Add player'),
      content: TextField(
        autofocus: true,
        onEditingComplete: buttonEnabled
            ? () async => Navigator.pop(
                  context,
                  await kothServerService.getPlayer(controller.text.trim()),
                )
            : null,
        onChanged: (value) {
          setState(() {
            buttonEnabled = controller.text.isNotEmpty;
          });
        },
        controller: controller,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: buttonEnabled
              ? () async => Navigator.pop(
                    context,
                    await kothServerService.getPlayer(controller.text.trim()),
                  )
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
