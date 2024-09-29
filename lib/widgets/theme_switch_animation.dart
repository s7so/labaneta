import 'package:flutter/material.dart';

class ThemeSwitchAnimation extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;

  const ThemeSwitchAnimation({
    Key? key,
    required this.child,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.grey[900]!, Colors.grey[800]!]
              : [Colors.white, Colors.pink[50]!],
        ),
      ),
      child: AnimatedDefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }
}