import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:labaneta_sweet/screens/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late ConfettiController _confettiController;
  bool _isLiked = false;
  int _quantity = 1;
  int _currentPage = 0;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack)
    );
    _scaleController.forward();
  }


  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(theme),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductTitle(theme),
                      const SizedBox(height: 16),
                      _buildPriceAndRating(theme),
                      const SizedBox(height: 24),
                      _buildDescription(theme),
                      const SizedBox(height: 24),
                      _buildQuantitySelector(theme),
                      const SizedBox(height: 24),
                      _buildNutritionInfo(theme),
                      const SizedBox(height: 24),
                      _buildReviewsSection(theme),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2, end: 0),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildAddToCartButton(cartProvider, theme),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [Colors.red, Colors.pink, Colors.orange, Colors.yellow, Colors.white],
              strokeWidth: 1,
              strokeColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: 3, // Assume we have 3 images for each product
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'product_image_${widget.product.id}_$index',
                  child: Image.asset(
                    widget.product.imageUrl, // This should be an array of images
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? theme.colorScheme.secondary : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
          onPressed: () {
            setState(() {
              _isLiked = !_isLiked;
              if (_isLiked) _confettiController.play();
            });
          },
        ).animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 1200.ms, color: Colors.red.withOpacity(0.7))
          .shake(hz: 4, curve: Curves.easeInOutCubic)
          .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
      ],
    );
  }

  Widget _buildProductTitle(ThemeData theme) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        widget.product.name,
        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPriceAndRating(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        RatingBar.builder(
          initialRating: 4.5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {
            // Handle rating update
          },
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      widget.product.description,
      style: theme.textTheme.bodyLarge,
    );
  }

  Widget _buildQuantitySelector(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildQuantityButton(Icons.remove, () {
          if (_quantity > 1) setState(() => _quantity--);
        }),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.secondary),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _quantity.toString(),
            style: theme.textTheme.titleLarge,
          ),
        ),
        _buildQuantityButton(Icons.add, () {
          setState(() => _quantity++);
        }),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
      .shimmer(duration: 1000.ms, color: Colors.white.withOpacity(0.5))
      .shake(hz: 4, curve: Curves.easeInOutCubic);
  }

  Widget _buildNutritionInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nutrition Information', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNutritionItem('Calories', '250', Icons.local_fire_department),
            _buildNutritionItem('Fat', '12g', Icons.opacity),
            _buildNutritionItem('Carbs', '30g', Icons.grain),
            _buildNutritionItem('Protein', '5g', Icons.fitness_center),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    ).animate()
      .fadeIn(duration: 600.ms)
      .scale(delay: 300.ms);
  }

  Widget _buildReviewsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Reviews', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildReviewItem('John Doe', 5, 'Absolutely delicious! Will order again.'),
        _buildReviewItem('Jane Smith', 4, 'Great taste, but a bit pricey.'),
        _buildReviewItem('Mike Johnson', 5, 'Best dessert I\'ve had in a while!'),
      ],
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: 200.ms)
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildAddToCartButton(CartProvider cartProvider, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          for (int i = 0; i < _quantity; i++) {
            cartProvider.addItem(widget.product);
          }
          _showAddedToCartAnimation();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart),
            const SizedBox(width: 8),
            Text(
              'Add to Cart - \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideY(begin: 1, end: 0);
  }

  void _showAddedToCartAnimation() {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Added to Cart!', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        content: Text('${_quantity}x ${widget.product.name} added to your cart.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue Shopping'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            child: const Text('Go to Cart'),
          ),
        ],
      ),
    );
  }
}