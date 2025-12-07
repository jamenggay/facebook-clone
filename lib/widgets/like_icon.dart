import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {

  final VoidCallback onPressed;
  final double iconSize;
  final Color textColor;

  const LikeButton({
    super.key,
    required this.onPressed,
    this.iconSize = 20,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Image.asset(
        'assets/icons/like.png',
        width: iconSize,
        height: iconSize,
      ),
      label: Text(
        'Like',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
