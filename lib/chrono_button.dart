import 'package:flutter/material.dart';

class ChronoButton extends StatelessWidget {
  const ChronoButton(
      {Key? key,
      required this.player,
      required this.color,
      required this.onPressed})
      : super(key: key);

  final Function() onPressed;
  final String player;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: Text(
        player,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 48.0,
        ),
      ),
    );
  }
}
