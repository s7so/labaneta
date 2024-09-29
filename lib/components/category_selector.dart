import 'package:flutter/material.dart';
import 'package:labaneta_sweet/utils/constants.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? Constants.paddingMedium : Constants.paddingSmall,
                right: index == categories.length - 1 ? Constants.paddingMedium : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: Constants.paddingMedium),
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? theme.colorScheme.secondary : theme.primaryColor,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}