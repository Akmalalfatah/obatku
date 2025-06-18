import 'package:flutter/material.dart';

class SearchChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const SearchChip({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text, style: TextStyle(color: textColor)),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    );
  }
}
