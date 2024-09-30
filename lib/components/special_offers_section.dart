import 'package:flutter/material.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:labaneta_sweet/utils/constants.dart';
import 'package:labaneta_sweet/screens/product_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SpecialOffersSection extends StatelessWidget {
  final List<Product> discountedProducts;

  const SpecialOffersSection({Key? key, required this.discountedProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Constants.paddingMedium),
          child: Text(
            'Special Offers',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ).animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: discountedProducts.length,
            itemBuilder: (context, index) {
              return _buildSpecialOfferCard(context, discountedProducts[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOfferCard(BuildContext context, Product product, int index) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
      ),
      child: Container(
        width: 200,
        margin: EdgeInsets.only(
          left: index == 0 ? Constants.paddingMedium : Constants.paddingSmall,
          right: index == discountedProducts.length - 1 ? Constants.paddingMedium : 0,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    product.imageUrl,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${product.discount!.toStringAsFixed(0)}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: 100 * index))
        .slideY(begin: 0.2, end: 0)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }
}