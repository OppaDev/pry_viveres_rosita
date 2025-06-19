import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final bool extended;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon = Icons.add,
    this.extended = true,
  });

  @override
  Widget build(BuildContext context) {
    if (extended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        label: Text(label),
        icon: Icon(icon),
      );
    } else {
      return FloatingActionButton(
        onPressed: onPressed,
        tooltip: label,
        child: Icon(icon),
      );
    }
  }
}
