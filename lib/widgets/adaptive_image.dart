import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  final String lightImage;
  final String darkImage;
  final bool isDarkMode;

  const AdaptiveImage({
    Key? key,
    required this.lightImage,
    required this.darkImage,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: Image.asset(lightImage),
      secondChild: Image.asset(darkImage),
      crossFadeState: isDarkMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }
}