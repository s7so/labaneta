import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/components/custom_app_bar.dart';
import 'package:labaneta_sweet/components/product_card.dart';
import 'package:labaneta_sweet/utils/constants.dart';
import 'package:labaneta_sweet/utils/app_theme.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/screens/product_details_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:labaneta_sweet/models/product.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _showBackToTopButton = _scrollController.offset >= 400;
    });
    _showBackToTopButton ? _animationController.forward() : _animationController.reverse();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = ['All', ...productProvider.categories];
    List<Product> products = _getFilteredAndSortedProducts(productProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Menu'),
      body: Column(
        children: [
          _buildCategoryFilter(categories),
          _buildSortButton(),
          Expanded(
            child: _buildProductGrid(products),
          ),
        ],
      ),
      floatingActionButton: _buildScrollToTopButton(),
    );
  }

  List<Product> _getFilteredAndSortedProducts(ProductProvider productProvider) {
    List<Product> products = _selectedCategory == 'All'
        ? List.from(productProvider.products)
        : List.from(productProvider.getProductsByCategory(_selectedCategory));

    products.sort((a, b) {
      switch (_sortBy) {
        case 'price':
          return a.price.compareTo(b.price);
        case 'popularity':
          return b.salesCount.compareTo(a.salesCount);
        default:
          return a.name.compareTo(b.name);
      }
    });

    return products;
  }

  Widget _buildCategoryFilter(List<String> categories) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAllCategoryButton();
          }
          return _buildCategoryChip(categories[index]);
        },
      ),
    );
  }

  Widget _buildAllCategoryButton() {
    final isSelected = _selectedCategory == 'All';
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Material(
        elevation: 4,
        shadowColor: theme.colorScheme.primary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: () => setState(() => _selectedCategory = 'All'),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(30),
              border: isSelected ? null : Border.all(color: theme.colorScheme.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.category,
                  size: 20,
                  color: isSelected ? Colors.white : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'All',
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        elevation: 2,
        shadowColor: theme.colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => setState(() => _selectedCategory = category),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.secondary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? theme.colorScheme.secondary : theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  size: 18,
                  color: isSelected ? Colors.white : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => _showSortOptions(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sort, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Sort by: ${_sortBy.capitalize()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sort Products', style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            ...[
              {'icon': Icons.sort_by_alpha, 'value': 'name', 'label': 'Name'},
              {'icon': Icons.attach_money, 'value': 'price', 'label': 'Price'},
              {'icon': Icons.trending_up, 'value': 'popularity', 'label': 'Popularity'},
            ].map((option) => ListTile(
              leading: Icon(option['icon'] as IconData, color: theme.colorScheme.secondary),
              title: Text(option['label'] as String),
              trailing: _sortBy == option['value']
                  ? Icon(Icons.check, color: theme.colorScheme.secondary)
                  : null,
              onTap: () {
                setState(() => _sortBy = option['value'] as String);
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return MasonryGridView.count(
      controller: _scrollController,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return AnimatedProductCard(
          product: product,
          index: index,
          onTap: () => _showQuickView(context, product),
        );
      },
    );
  }

  Widget _buildScrollToTopButton() {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cakes':
        return Icons.cake;
      case 'cupcakes':
        return Icons.local_dining;
      case 'pastries':
        return Icons.bakery_dining;
      case 'chocolates':
        return Icons.emoji_food_beverage;
      default:
        return Icons.category;
    }
  }

  void _showQuickView(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQuickViewContent(context, product),
    );
  }

  Widget _buildQuickViewContent(BuildContext context, Product product) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildQuickViewImage(product),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                _buildPriceRow(context, product),
                const SizedBox(height: 16),
                Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                _buildViewDetailsButton(context, product),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickViewImage(Product product) {
    return Stack(
      children: [
        Hero(
          tag: 'product_image_${product.id}',
          child: Image.asset(
            product.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context, Product product) {
    return Row(
      children: [
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (product.discount != null)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '\$${(product.price / (1 - product.discount! / 100)).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildViewDetailsButton(BuildContext context, Product product) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text('View Details'),
    );
  }
}

class AnimatedProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final VoidCallback onTap;

  const AnimatedProductCard({
    Key? key,
    required this.product,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(0, index * 10.0, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // صورة المنتج
                Hero(
                  tag: 'product_image_${product.id}',
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                // طبقة التدرج
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // معلومات المنتج
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // شارة "جديد" أو "الأكثر مبيعًا"
                if (index == 0 || product.salesCount > 100)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.green : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        index == 0 ? 'NEW' : 'BEST',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}