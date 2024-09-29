// lib/providers/loyalty_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loyalty_program.dart';

class LoyaltyProvider with ChangeNotifier {
  int _points = 0;
  late LoyaltyLevel _currentLevel;

  int get points => _points;
  LoyaltyLevel get currentLevel => _currentLevel;

  LoyaltyProvider() {
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('loyalty_points') ?? 0;
    _updateLevel();
    notifyListeners();
  }

  Future<void> _savePoints() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loyalty_points', _points);
  }

  Future<void> addPoints(int newPoints) async {
    _points += newPoints;
    await _updateLevelAndSave();
  }

  Future<void> deductPoints(int pointsToDeduct) async {
    if (_points >= pointsToDeduct) {
      _points -= pointsToDeduct;
      await _updateLevelAndSave();
    } else {
      throw InsufficientPointsException('Insufficient points to deduct $pointsToDeduct from current balance of $_points');
    }
  }

  Future<void> _updateLevelAndSave() async {
    _updateLevel();
    await _savePoints();
    notifyListeners();
  }

  void _updateLevel() {
    _currentLevel = LoyaltyProgram.getLevelForPoints(_points);
  }

  double getDiscountForPurchase(double amount) {
    return amount * (_currentLevel.discountPercentage / 100);
  }

  bool canRedeemReward(int requiredPoints) {
    return _points >= requiredPoints;
  }
}

class InsufficientPointsException implements Exception {
  final String message;
  InsufficientPointsException(this.message);

  @override
  String toString() => 'InsufficientPointsException: $message';
}