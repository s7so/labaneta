import 'package:flutter/foundation.dart';
import 'package:labaneta_sweet/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [
    // Add some sample products here
    Product(
      id: '1',
      name: 'Chocolate Cake',
      imageUrl: 'https://via.placeholder.com/150',
      price: 29.99,
      description: 'Delicious chocolate cake with rich frosting.',
      category: 'Cakes',
    ),
    Product(
      id: '2',
      name: 'Vanilla Cupcakes',
      imageUrl: 'https://via.placeholder.com/150',
      price: 14.99,
      description: 'Light and fluffy vanilla cupcakes with buttercream frosting.',
      category: 'Cupcakes',
    ),
    // Add more sample products...
  ];

  List<Product> get products => [..._products];

  List<Product> getProductsByCategory(String category) {
    if (category == 'All') {
      return products;
    }
    return _products.where((product) => product.category == category).toList();
  }

  Product getProductById(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}