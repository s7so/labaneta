import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/bottom_nav_bar.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/screens/menu_screen.dart';
import 'package:labaneta_sweet/components/search_bar.dart' as custom_search_bar;
import 'package:labaneta_sweet/components/special_offers_section.dart';
import 'package:labaneta_sweet/components/best_selling_section.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:labaneta_sweet/theme/app_theme.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _selectedCategoryIndex = 0;

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
  }

  @override
  void dispose() {
    _controller.dispose();
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              _navigateToMenu(context);
              break;
            case 2:
              // TODO: Implement navigation to Cart screen
              break;
            case 3:
              // TODO: Implement navigation to Profile screen
              break;
          }
        },
      ),
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
            // Handle notifications
          },
        ),
      ],
    );
  }

  Widget _buildPromotionalBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
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
        return BestSellingSection(
          bestSellingProducts: productProvider.bestSellingProducts.take(5).toList(),
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
}