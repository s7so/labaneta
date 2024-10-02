import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/screens/menu_screen.dart';
import 'package:labaneta_sweet/components/search_bar.dart' as custom_search_bar;
import 'package:labaneta_sweet/components/special_offers_section.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:labaneta_sweet/screens/product_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:labaneta_sweet/theme/app_theme.dart';
import 'dart:math' as math;
import 'package:labaneta_sweet/screens/cart_screen.dart';
import 'package:labaneta_sweet/screens/profile_screen.dart';
import 'package:labaneta_sweet/screens/favorites_screen.dart';
import 'package:labaneta_sweet/screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bottomNavAnimationController;
  late Animation<double> _bottomNavAnimation;
  int _selectedCategoryIndex = 0;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Cakes', 'icon': Icons.cake, 'color': AppColors.primary},
    {'name': 'Cupcakes', 'icon': Icons.local_dining, 'color': AppColors.secondary},
    {'name': 'Pastries', 'icon': Icons.bakery_dining, 'color': AppColors.tertiary},
    {'name': 'Chocolates', 'icon': Icons.emoji_food_beverage, 'color': AppColors.accent},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _bottomNavAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bottomNavAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bottomNavAnimationController, curve: Curves.easeInOut),
    );
    _bottomNavAnimationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bottomNavAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildPromotionalBanner(context),
                _buildSearchBar(),
                _buildCategorySection(context),
                _buildSpecialOffers(context),
                _buildBestSelling(context),
                _buildFullMenuSection(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildAdvancedBottomNavBar(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Labanita Sweets',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 2, offset: const Offset(1, 1))],
            )),
        background: Image.asset(
          'assets/images/432438460_122093157200249042_6397283536549608588_n.jpg',
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationScreen()),
            );
          },
        ).animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.5))
          .shake(hz: 4, curve: Curves.easeInOutCubic),
      ],
    );
  }

  Widget _buildPromotionalBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            bottom: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Special Offer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '20% off on all cakes this week!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _navigateToMenu(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: custom_search_bar.SearchBar(
        onChanged: (query) {
          // Handle search query
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Categories',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ).animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(context, categories[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category, int index) {
    final isSelected = _selectedCategoryIndex == index;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          final value = math.sin((_controller.value + index / categories.length) * 2 * math.pi);
          return Transform.translate(
            offset: Offset(0, 4 * value),
            child: child,
          );
        },
        child: Container(
          width: 100,
          margin: EdgeInsets.only(
            left: index == 0 ? 16 : 8,
            right: index == categories.length - 1 ? 16 : 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected ? category['color'] : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected ? category['color'].withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  category['icon'],
                  color: isSelected ? Colors.white : category['color'],
                  size: 40,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category['name'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? category['color'] : AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ).animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: 100 * index))
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }

  Widget _buildSpecialOffers(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return SpecialOffersSection(
          discountedProducts: productProvider.discountedProducts,
        );
      },
    );
  }

  Widget _buildBestSelling(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final bestSellingProducts = productProvider.bestSellingProducts.take(5).toList();
        if (bestSellingProducts.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Best Selling',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ).animate()
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.2, end: 0),
            ),
            SizedBox(
              height: 340,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bestSellingProducts.length,
                itemBuilder: (context, index) {
                  final product = bestSellingProducts[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == bestSellingProducts.length - 1 ? 16 : 8,
                    ),
                    child: BestSellingProductCard(
                      product: product,
                      index: index,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      ),
                    ),
                  ).animate()
                    .fadeIn(duration: 600.ms, delay: Duration(milliseconds: 100 * index))
                    .slideY(begin: 0.2, end: 0)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFullMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Our Full Menu',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToMenu(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('View All Products'),
          ),
        ],
      ),
    );
  }

  void _navigateToMenu(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildAdvancedBottomNavBar() {
    return AnimatedBuilder(
      animation: _bottomNavAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _bottomNavAnimation.value)),
          child: Opacity(
            opacity: _bottomNavAnimation.value,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 'Home', 0),
                  _buildNavItem(Icons.menu_book, 'Menu', 1),
                  _buildNavItem(Icons.shopping_cart, 'Cart', 2),
                  _buildNavItem(Icons.person, 'Profile', 3),
                  _buildNavItem(Icons.favorite, 'Favorites', 4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = index == _currentIndex;
    return GestureDetector(
      onTap: () => _onNavItemTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ).animate()
        .scale(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          begin: const Offset(1, 1),
          end: isSelected ? const Offset(1.1, 1.1) : const Offset(1, 1),
        )
        .shimmer(
          duration: const Duration(milliseconds: 1000),
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.3) : Colors.transparent,
        ),
    );
  }

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        _navigateToMenu(context);
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesScreen()),
        );
        break;
    }
  }
}

class BestSellingProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final VoidCallback onTap;

  const BestSellingProductCard({
    Key? key,
    required this.product,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    product.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${(4.5 + index * 0.1).toStringAsFixed(1)} (${1000 + index * 100})',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildAddToCartButton(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Best Seller #${index + 1}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (product.discount != null)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${product.discount}% OFF',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement add to cart functionality
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_shopping_cart, size: 16),
          SizedBox(width: 4),
          Text('Add', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}