// lib/widgets/available_rewards.dart
import 'package:flutter/material.dart';
import '../providers/loyalty_provider.dart';

class AvailableRewards extends StatelessWidget {
  final LoyaltyProvider loyaltyProvider;

  const AvailableRewards({Key? key, required this.loyaltyProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is a placeholder. You would typically fetch this data from an API or local database.
    final rewards = [
      {'name': 'Free Cupcake', 'points': 500},
      {'name': '50% Off Next Purchase', 'points': 1000},
      {'name': 'Exclusive Tasting Event', 'points': 2000},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final canRedeem = loyaltyProvider.canRedeemReward(reward['points'] as int);
        return Card(
          child: ListTile(
            title: Text(reward['name'] as String),
            subtitle: Text('${reward['points']} points'),
            trailing: ElevatedButton(
              onPressed: canRedeem
                  ? () async {
                      try {
                        await loyaltyProvider.deductPoints(reward['points'] as int);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reward redeemed!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  : null,
              child: const Text('Redeem'),
            ),
          ),
        );
      },
    );
  }
}