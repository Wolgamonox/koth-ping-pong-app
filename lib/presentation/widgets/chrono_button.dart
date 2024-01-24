import 'package:flutter/material.dart';

class ChronoButton extends StatelessWidget {
  const ChronoButton(
      {super.key,
        required this.name,
        required this.isKing,
        required this.onPressed});

  final Function()? onPressed;
  final String name;
  final bool isKing;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> props = {
      'style': FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      'child': Text(
        name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    };

    if (isKing) {
      return FilledButton.tonal(
        onPressed: onPressed,
        style: props['style'],
        child: props['child'],
      );
    } else {
      return OutlinedButton(
        onPressed: onPressed,
        style: props['style'],
        child: props['child'],
      );
    }
  }
}
