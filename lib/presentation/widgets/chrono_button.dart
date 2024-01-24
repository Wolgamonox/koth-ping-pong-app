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
    return FilledButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
