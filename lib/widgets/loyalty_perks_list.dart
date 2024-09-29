// lib/widgets/loyalty_perks_list.dart
import 'package:flutter/material.dart';
import '../models/loyalty_program.dart';

class LoyaltyPerksList extends StatelessWidget {
  final LoyaltyLevel level;

  const LoyaltyPerksList({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: level.perks.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
            title: Text(level.perks[index]),
          );
        },
      ),
    );
  }
}

