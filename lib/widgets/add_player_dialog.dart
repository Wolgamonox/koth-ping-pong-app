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

  void _onPlayerUsernameEntered() async {
    Navigator.pop(
        context,
        await ref.read(kothServerServiceProvider.notifier).getPlayer(controller.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add player'),
      content: TextField(
        autofocus: true,
        onEditingComplete: buttonEnabled
            ? _onPlayerUsernameEntered
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
              ? _onPlayerUsernameEntered
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
