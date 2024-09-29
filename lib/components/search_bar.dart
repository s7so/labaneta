import 'package:flutter/material.dart';
import 'package:labaneta_sweet/utils/constants.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Constants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search for sweets...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: theme.colorScheme.secondary),
        ),
      ),
    );
  }
}