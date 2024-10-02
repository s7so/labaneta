import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/product_provider.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:labaneta_sweet/screens/product_details_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:labaneta_sweet/components/product_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  String _selectedCategory = 'All'; // تخزين الفئة المحددة حاليًا
  String _sortBy = 'name'; // تخزين طريقة الفرز الحالية
  late ScrollController _scrollController; // وحدة التحكم في التمرير
  bool _showFloatingButton = false; // تحديد ما إذا كان سيتم عرض الزر العائم أم لا

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _showFloatingButton = _scrollController.offset > 200; // إظهار الزر العائم عندما يتجاوز التمرير 200 بكسل
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // التخلص من وحدة التحكم في التمرير عند تدمير الشاشة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final categories = ['All', ...productProvider.categories]; // الحصول على قائمة الفئات
        final products = _getFilteredAndSortedProducts(productProvider); // الحصول على المنتجات المفلترة والمرتبة

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(context), // بناء شريط التطبيق
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildCategoryFilter(categories), // بناء مرشح الفئات
                    _buildSortButton(), // بناء زر الفرز
                  ],
                ),
              ),
              _buildProductGrid(products), // بناء شبكة المنتجات
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(), // بناء الزر العائم
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    // بناء شريط التطبيق باستخدام SliverAppBar
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
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/432438460_122093157200249042_6397283536549608588_n.jpg',
              fit: BoxFit.cover,
            ),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(List<String> categories) {
    // بناء مرشح الفئات
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildCategoryChip(categories[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    // بناء رقاقة الفئة
    final isSelected = _selectedCategory == category;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedCategory = category);
        },
        selectedColor: theme.colorScheme.secondary,
        backgroundColor: theme.colorScheme.surface,
        labelStyle: TextStyle(
          color: isSelected ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate()
      .fadeIn(duration: 300.ms)
      .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1));
  }

  Widget _buildSortButton() {
    // بناء زر الفرز
    return ElevatedButton.icon(
      icon: const Icon(Icons.sort),
      label: Text('Sort: ${_sortBy.capitalize()}'),
      onPressed: _showSortOptions,
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    ).animate()
      .fadeIn(duration: 300.ms)
      .slideY(begin: 0.2, end: 0);
  }

  void _showSortOptions() {
    // عرض خيارات الفرز في BottomSheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Sort by'),
            tileColor: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.onSecondary,
          ),
          ...[
            {'icon': Icons.sort_by_alpha, 'value': 'name', 'label': 'Name'},
            {'icon': Icons.attach_money, 'value': 'price', 'label': 'Price'},
            {'icon': Icons.trending_up, 'value': 'popularity', 'label': 'Popularity'},
          ].map((option) => ListTile(
            leading: Icon(option['icon'] as IconData),
            title: Text(option['label'] as String),
            trailing: _sortBy == option['value']
                ? const Icon(Icons.check)
                : null,
            onTap: () {
              setState(() => _sortBy = option['value'] as String);
              Navigator.pop(context);
            },
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: ProductCard(
                    product: products[index],
                    onTap: () => _navigateToProductDetails(products[index]),
                  ),
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    // بناء الزر العائم للانتقال إلى أعلى الصفحة
    return AnimatedOpacity(
      opacity: _showFloatingButton ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ).animate()
        .scale(duration: 300.ms, curve: Curves.easeOut)
        .fade(duration: 300.ms),
    );
  }

  List<Product> _getFilteredAndSortedProducts(ProductProvider productProvider) {
    // الحصول على المنتجات المفلترة والمرتبة
    List<Product> products = _selectedCategory == 'All'
        ? List.from(productProvider.products)
        : productProvider.getProductsByCategory(_selectedCategory);

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

  void _navigateToProductDetails(Product product) {
    // الانتقال إلى شاشة تفاصيل المنتج
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProductDetailsScreen(product: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    // تحويل الحرف الأول من السلسلة إلى حرف كبير
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}