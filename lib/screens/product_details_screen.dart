import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/custom_app_bar.dart';
import 'package:labaneta_sweet/components/custom_button.dart';
import 'package:labaneta_sweet/utils/constants.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:photo_view/photo_view.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String _selectedSize = 'M';
  String _selectedFlavor = 'Original';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: widget.product.name),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showEnlargedImage(context),
              child: Hero(
                tag: 'product_image_${widget.product.id}',
                child: Image.asset(
                  widget.product.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Constants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: theme.textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _buildSizeSelector(),
                  const SizedBox(height: 16),
                  _buildFlavorSelector(),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Add to Cart',
                    onPressed: () {
                      cartProvider.addItem(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.product.name} added to cart'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              cartProvider.removeSingleItem(widget.product.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildReviewsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Size', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'L'].map((size) {
            return GestureDetector(
              onTap: () => setState(() => _selectedSize = size),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedSize == size ? theme.colorScheme.secondary : Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      color: _selectedSize == size ? theme.colorScheme.onSecondary : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFlavorSelector() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Flavor', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Original', 'Chocolate', 'Vanilla', 'Strawberry'].map((flavor) {
            return ChoiceChip(
              label: Text(flavor),
              selected: _selectedFlavor == flavor,
              onSelected: (selected) {
                setState(() => _selectedFlavor = flavor);
              },
              selectedColor: theme.colorScheme.secondary,
              labelStyle: TextStyle(
                color: _selectedFlavor == flavor ? theme.colorScheme.onSecondary : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    // This is a mock reviews section. You can replace it with real data later.
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildReviewItem('John Doe', 5, 'Absolutely delicious! Will order again.'),
        _buildReviewItem('Jane Smith', 4, 'Great taste, but a bit pricey.'),
        _buildReviewItem('Mike Johnson', 5, 'Best dessert I\'ve had in a while!'),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: theme.textTheme.titleMedium),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: theme.colorScheme.secondary,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _showEnlargedImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Container(
            child: PhotoView(
              imageProvider: AssetImage(widget.product.imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        ),
      ),
    );
  }
}