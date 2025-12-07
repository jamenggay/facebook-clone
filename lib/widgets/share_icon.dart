import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double iconSize;
  final Color textColor;

  const ShareButton({
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
        'assets/icons/share.png',
        width: iconSize,
        height: iconSize,
      ),
      label: Text(
        'Share',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
