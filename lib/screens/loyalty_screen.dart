// lib/screens/loyalty_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loyalty_provider.dart';
import '../models/loyalty_program.dart';
import '../widgets/loyalty_progress_bar.dart';
import '../widgets/loyalty_perks_list.dart';
import '../widgets/available_rewards.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoyaltyProvider>(
      builder: (context, loyaltyProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('My Rewards')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoyaltyCard(context, loyaltyProvider),
                const SizedBox(height: 24),
                Text('Your Perks', style: Theme.of(context).textTheme.titleLarge),
                LoyaltyPerksList(level: loyaltyProvider.currentLevel),
                const SizedBox(height: 24),
                Text('Available Rewards', style: Theme.of(context).textTheme.titleLarge),
                AvailableRewards(loyaltyProvider: loyaltyProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoyaltyCard(BuildContext context, LoyaltyProvider loyaltyProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${loyaltyProvider.currentLevel.name} Member',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${loyaltyProvider.points} points',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            LoyaltyProgressBar(
              currentPoints: loyaltyProvider.points,
              nextLevel: LoyaltyProgram.getLevelForPoints(loyaltyProvider.points + 1),
            ),
          ],
        ),
      ),
    );
  }
}