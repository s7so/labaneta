// lib/widgets/loyalty_progress_bar.dart
import 'package:flutter/material.dart';
import '../models/loyalty_program.dart';

class LoyaltyProgressBar extends StatelessWidget {
  final int currentPoints;
  final LoyaltyLevel nextLevel;

  const LoyaltyProgressBar({
    Key? key,
    required this.currentPoints,
    required this.nextLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = currentPoints / nextLevel.requiredPoints;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          '${nextLevel.requiredPoints - currentPoints} points to ${nextLevel.name}',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

