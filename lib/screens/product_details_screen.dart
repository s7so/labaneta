// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/cart_provider.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:labaneta_sweet/screens/cart_screen.dart';
import 'package:labaneta_sweet/providers/favorites_provider.dart';
import 'package:labaneta_sweet/screens/review_screen.dart';
import 'package:labaneta_sweet/providers/review_provider.dart';

// Main widget for the product details screen
class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

// State class for ProductDetailsScreen
class _ProductDetailsScreenState extends State<ProductDetailsScreen> with TickerProviderStateMixin {
  // Controllers and variables for various UI elements
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
    // Initializing controllers and animations
    _pageController = PageController(viewportFraction: 0.85);
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack)
    );
    _scaleController.forward();
    // Fetching reviews for the product
    Provider.of<ReviewProvider>(context, listen: false).fetchReviews();
  }

  @override
  void dispose() {
    // Disposing controllers to free up resources
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
          _buildBackground(theme),
          _buildProductImages(),
          _buildProductDetails(theme),
          _buildFloatingActionButton(cartProvider, theme),
          _buildConfetti(),
        ],
      ),
    );
  }

  // Widget to build the background gradient
  Widget _buildBackground(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.secondary.withOpacity(0.4),
            theme.colorScheme.primary.withOpacity(0.4),
          ],
        ),
      ),
    );
  }

  // Widget to build the product image carousel
  Widget _buildProductImages() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.5,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 1, // Change this to 1 since we have only one image
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(
                tag: 'product_image_${widget.product.id}',
                child: Image.asset(
                  widget.product.imageUrl, // Use imageUrl instead of imageUrls[index]
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget to build the product details section
  Widget _buildProductDetails(ThemeData theme) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.5 - 30,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
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
              _buildWhyYoullLoveIt(theme),
              const SizedBox(height: 24),
              _buildReviewsSection(theme),
            ],
          ),
        ),
      ),
    );
  }
  // Widget to build the product title with animation
  Widget _buildProductTitle(ThemeData theme) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        widget.product.name,
        style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget to build the price and rating section
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

  // Widget to build the product description
  Widget _buildDescription(ThemeData theme) {
    return Text(
      widget.product.description,
      style: theme.textTheme.bodyLarge,
    );
  }

  // Widget to build the quantity selector
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

  // Widget to build the quantity adjustment buttons with animations
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

  // Widget to build the nutrition information section
  Widget _buildWhyYoullLoveIt(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Why You\'ll Love It', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildFeatureItem(
          'Handcrafted with Love',
          'Each treat is carefully handmade with the finest ingredients and attention to detail.',
          Icons.favorite,
        ),
        _buildFeatureItem(
          'Indulgent Flavors',
          'Experience a burst of heavenly flavors that will tantalize your taste buds.',
          Icons.restaurant,
        ),
        _buildFeatureItem(
          'Perfect for Sharing',
          'Spread joy by sharing these delightful treats with your loved ones.',
          Icons.people,
        ),
        _buildFeatureItem(
          'Elegant Packaging',
          'Beautifully packaged, making it a perfect gift for any occasion.',
          Icons.card_giftcard,
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.2, end: 0);
  }

  // Widget to build the reviews section
  Widget _buildReviewsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Customer Reviews', style: theme.textTheme.titleLarge),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReviewScreen(product: widget.product)),
                );
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            RatingBarIndicator(
              rating: Provider.of<ReviewProvider>(context).getAverageRatingForProduct(widget.product.id),
              itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '${Provider.of<ReviewProvider>(context).getReviewsForProduct(widget.product.id).length} reviews',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Show a few review items
        ...Provider.of<ReviewProvider>(context)
            .getReviewsForProduct(widget.product.id)
            .take(3)
            .map((review) => _buildReviewItem(review.userName, review.rating.toInt(), review.comment))
            .toList(),
      ],
    );
  }

  // Widget to build individual review items with animations
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

  // Widget to build the floating action button for adding to cart
  Widget _buildFloatingActionButton(CartProvider cartProvider, ThemeData theme) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton.extended(
        onPressed: () {
          for (int i = 0; i < _quantity; i++) {
            cartProvider.addItem(widget.product);
          }
          _showAddedToCartAnimation();
        },
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_cart),
        label: const Text('Add to Cart'),
      ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 1, end: 0)
        .then() // Delay the next animation
        .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.5))
        .shake(hz: 4, curve: Curves.easeInOutCubic),
    );
  }

  // Widget to build the confetti effect
  Widget _buildConfetti() {
    return Align(
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
    );
  }

  // Method to show the "Added to Cart" animation and dialog
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
