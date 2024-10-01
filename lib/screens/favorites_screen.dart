import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:labaneta_sweet/providers/favorites_provider.dart';
import 'package:labaneta_sweet/models/product.dart';
import 'package:labaneta_sweet/screens/product_details_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearAllConfirmation(context),
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;
          if (favorites.isEmpty) {
            return _buildEmptyFavorites(context);
          } else {
            return _buildFavoritesList(favorites);
          }
        },
      ),
    );
  }

  Widget _buildEmptyFavorites(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on a product to add it to your favorites',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildFavoritesList(List<Product> favorites) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final product = favorites[index];
        return _buildFavoriteItem(context, product, index);
      },
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Product product, int index) {
    return Slidable(
      key: ValueKey(product.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _removeFromFavorites(context, product),
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(product.imageUrl),
        ),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: const Icon(Icons.favorite, color: Colors.red),
        onTap: () => _navigateToProductDetails(context, product),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: Duration(milliseconds: 100 * index)).slideX(begin: index.isEven ? -0.2 : 0.2, end: 0);
  }

  void _removeFromFavorites(BuildContext context, Product product) {
    Provider.of<FavoritesProvider>(context, listen: false).removeFromFavorites(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} removed from favorites'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => Provider.of<FavoritesProvider>(context, listen: false).addToFavorites(product),
        ),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
    );
  }

  void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all products from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<FavoritesProvider>(context, listen: false).clearFavorites();
              Navigator.pop(context);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}