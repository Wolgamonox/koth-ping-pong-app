import 'package:flutter/material.dart';

Future<String?> openAddPlayerDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    builder: (context) {
      return const AddPlayerDialog();
    },
  );
}

class AddPlayerDialog extends StatefulWidget {
  const AddPlayerDialog({Key? key}) : super(key: key);

  @override
  State<AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  TextEditingController controller = TextEditingController();

  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add player'),
      content: TextField(
        autofocus: true,
        onEditingComplete: buttonEnabled
            ? () => Navigator.pop(context, controller.text)
            : null,
        onChanged: (value) {
          setState(() {
            buttonEnabled = controller.text.length > 2;
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
              ? () => Navigator.pop(context, controller.text.trim())
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
