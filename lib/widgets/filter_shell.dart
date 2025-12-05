// lib/widgets/filter_shell.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; // para usar AppTheme.grayBG

class FilterShell extends StatelessWidget {
  final Color headerColor;
  final String titleLink;
  final IconData titleIcon;
  final Widget child;
  final Widget? bottomBar;

  const FilterShell({
    super.key,
    required this.headerColor,
    required this.titleLink,
    required this.titleIcon,
    required this.child,
    this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👇 antes: backgroundColor: headerColor,
      backgroundColor: AppTheme.grayBG,
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,
        leading: const SizedBox.shrink(),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            Icon(titleIcon, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              titleLink,
              style: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: child,
        ),
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
