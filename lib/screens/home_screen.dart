import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/bottom_nav_bar.dart';
import 'package:labaneta_sweet/utils/constants.dart';
import 'package:labaneta_sweet/utils/app_theme.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/screens/menu_screen.dart';
import 'package:labaneta_sweet/components/search_bar.dart' as custom_search_bar;
import 'package:labaneta_sweet/components/special_offers_section.dart';
import 'package:labaneta_sweet/components/best_selling_section.dart';
import 'package:labaneta_sweet/components/promotional_banner.dart';
import 'package:labaneta_sweet/components/circular_category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> _categories = [
    {'name': 'Cakes', 'icon': Icons.cake},
    {'name': 'Cupcakes', 'icon': Icons.local_dining},
    {'name': 'Pastries', 'icon': Icons.bakery_dining},
    {'name': 'Chocolates', 'icon': Icons.emoji_food_beverage},
  ];

  static const List<Map<String, String>> _promotions = [
    {'text': 'عرض خاص: خصم 20% على جميع الكيك!', 'action': 'cakes'},
    {'text': 'جديد: كب كيك بنكهة الفراولة والفانيليا', 'action': 'cupcakes'},
    {'text': 'اطلب الآن واحصل على توصيل مجاني للطلبات فوق 50\$', 'action': 'delivery'},
    {'text': 'تذوق طعم الإبداع مع حلوياتنا المميزة', 'action': 'specials'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.getGradientDecoration(Theme.of(context).brightness == Brightness.dark),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildAppBar(context),
                const PromotionalBanner(promotions: _promotions),
                Padding(
                  padding: const EdgeInsets.all(Constants.paddingMedium),
                  child: custom_search_bar.SearchBar(
                    onChanged: (query) {
                      // Handle search query
                    },
                  ),
                ),
                _buildCategories(),
                Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return BestSellingSection(
                      bestSellingProducts: productProvider.bestSellingProducts.take(5).toList(),
                    );
                  },
                ),
                Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return SpecialOffersSection(
                      discountedProducts: productProvider.discountedProducts,
                    );
                  },
                ),
                _buildFullMenuSection(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Labanita Sweets', 
        style: Theme.of(context).textTheme.headlineSmall),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_book),
          onPressed: () => _navigateToMenuScreen(context),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircularCategoryCard(
              category: _categories[index]['name'],
              icon: _categories[index]['icon'],
              onTap: () {
                // TODO: Navigate to category screen
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Our Full Menu',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore all our delicious sweets and treats',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.menu_book, color: Colors.white),
            label: const Text('View Full Menu'),
            onPressed: () => _navigateToMenuScreen(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMenuScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuScreen()),
    );
  }
}