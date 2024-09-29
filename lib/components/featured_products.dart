import 'package:flutter/material.dart';
import 'package:labaneta_sweet/components/product_card.dart';
import 'package:labaneta_sweet/models/product.dart';

class FeaturedProducts extends StatelessWidget {
  final List<Product> products;

  const FeaturedProducts({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Featured Products',
            style: theme.textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                name: product.name,
                imageUrl: product.imageUrl,
                price: product.price,
                isNew: index == 0, // Example: Mark the first product as new
                isBestSeller: product.salesCount > 100, // Example: Mark as best seller if sales > 100
                onTap: () {
                  // TODO: Navigate to product details
                },
              );
            },
          ),
        ),
      ],
    );
  }
}