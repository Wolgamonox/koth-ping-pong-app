import 'package:flutter/material.dart';

class ChronoButton extends StatelessWidget {
  const ChronoButton(
      {super.key,
      required this.playerFullName,
      required this.color,
      required this.onPressed});

  final Function()? onPressed;
  final String playerFullName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: Text(
        playerFullName,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
