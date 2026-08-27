import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double iconSize;
  final Color textColor;

  final bool isLiked;

  const LikeButton({
    super.key,
    required this.onPressed,
    this.iconSize = 20,
    required this.textColor,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
        size: iconSize,
        color: textColor,
      ),
      label: Text('Like', style: TextStyle(color: textColor, fontSize: 12)),
    );
  }
}
