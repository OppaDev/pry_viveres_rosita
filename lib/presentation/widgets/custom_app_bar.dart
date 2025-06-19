import 'package:flutter/material.dart';
import 'package:pry_viveres_rosita/presentation/widgets/theme_toggle_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showThemeToggle;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showThemeToggle = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> appBarActions = [];

    if (actions != null) {
      appBarActions.addAll(actions!);
    }

    if (showThemeToggle) {
      appBarActions.add(const ThemeToggleButton());
    }

    return AppBar(
      title: Text(title),
      leading: leading,
      actions: appBarActions.isNotEmpty ? appBarActions : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
