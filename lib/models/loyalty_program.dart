// lib/models/loyalty_program.dart
import 'package:flutter/foundation.dart';

@immutable
class LoyaltyLevel {
  final String name;
  final int requiredPoints;
  final double discountPercentage;
  final List<String> perks;

  const LoyaltyLevel({
    required this.name,
    required this.requiredPoints,
    required this.discountPercentage,
    required this.perks,
  });
}

class LoyaltyProgram {
  static const double pointsPerDollar = 10;
  static final List<LoyaltyLevel> levels = [
    const LoyaltyLevel(
      name: 'Bronze',
      requiredPoints: 0,
      discountPercentage: 0,
      perks: ['Welcome gift'],
    ),
    const LoyaltyLevel(
      name: 'Silver',
      requiredPoints: 1000,
      discountPercentage: 5,
      perks: ['5% discount', 'Free delivery'],
    ),
    const LoyaltyLevel(
      name: 'Gold',
      requiredPoints: 5000,
      discountPercentage: 10,
      perks: ['10% discount', 'Free delivery', 'Priority support'],
    ),
    const LoyaltyLevel(
      name: 'Platinum',
      requiredPoints: 10000,
      discountPercentage: 15,
      perks: ['15% discount', 'Free delivery', 'Priority support', 'Exclusive events'],
    ),
  ];

  static LoyaltyLevel getLevelForPoints(int points) {
    return levels.lastWhere(
      (level) => points >= level.requiredPoints,
      orElse: () => levels.first,
    );
  }

  static int calculatePointsForPurchase(double amount) {
    return (amount * pointsPerDollar).round();
  }

  const LoyaltyProgram._();
}