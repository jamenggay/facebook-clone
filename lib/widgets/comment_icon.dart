import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double iconSize;
  final Color textColor;

  const CommentButton({
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
        'assets/icons/comment.png',
        width: iconSize,
        height: iconSize,
      ),
      label: Text(
        'Comment',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
