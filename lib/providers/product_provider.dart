import 'package:flutter/foundation.dart';
import 'package:labaneta_sweet/models/product.dart';

class ProductProvider with ChangeNotifier {
  // List to store all the products
  final List<Product> _products = [
    // Initialize with some dummy products or load from a data source
    Product(
      id: '1',
      name: 'أم علي كيندر',
      imageUrl: 'assets/images/Snapinsta.app_457655639_17877747087111070_1916740654224851618_n_1080.jpg',
      price: 29.99,
      description: 'Decadent chocolate cake with rich, velvety frosting.',
      category: 'Cakes',
      discount: 15,
      salesCount: 120,
    ),
    Product(
      id: '2',
      name: 'قشطوطة مع رز بلبن',
      imageUrl: 'assets/images/Snapinsta.app_452231901_17872956402111070_3555586632697640864_n_1080.jpg',
      price: 14.99,
      description: 'Light and fluffy vanilla cupcakes with creamy buttercream frosting.',
      category: 'Cupcakes',
      discount: 15,
      salesCount: 90,
    ),
    Product(
      id: '3',
      name: 'قلابيظو',
      imageUrl: 'assets/images/Snapinsta.app_459825845_17879909298111070_4417558691110981031_n_1080.jpg',
      price: 19.99,
      description: 'Buttery tart shell filled with vanilla custard and topped with fresh strawberries.',
      category: 'Tarts',
      salesCount: 80,
    ),
    Product(
      id: '4',
      name: 'طاجن كيندر',
      imageUrl: 'assets/images/Snapinsta.app_460153356_17879758413111070_8037308085088273541_n_1080.jpg',
      price: 12.99,
      description: 'Moist muffins bursting with juicy blueberries and a hint of lemon zest.',
      category: 'Muffins',
      salesCount: 110,
    ),
    Product(
      id: '5',
      name: 'بروفيترول',
      imageUrl: 'assets/images/بروفيترول.jpg',
      price: 14.99,
      description: 'Light and fluffy vanilla cupcakes with creamy buttercream frosting.',
      category: 'Cupcakes',
      salesCount: 90,
    ),
    Product(
      id: '6',
      name: 'تشيز كيك بستاشيو',
      imageUrl: 'assets/images/تشيز كيك بستاشيو.jpg',
      price: 14.99,
      description: 'Light and fluffy vanilla cupcakes with creamy buttercream frosting.',
      category: 'Cupcakes',
      salesCount: 90,
    ),
    Product(
      id: '7',
      name: 'رز بلبن نوتيلا',
      imageUrl: 'assets/images/رز بلبن نوتيلا.jpg',
      price: 14.99,
      description: 'Light and fluffy vanilla cupcakes with creamy buttercream frosting.',
      category: 'Cupcakes',
      discount: 15,
      salesCount: 120,
    ),
    Product(
      id: '8',
      name: 'كنافة بستاشيو',
      imageUrl: 'assets/images/كنافة بستاشيو.jpg',
      price: 14.99,
      description: 'Light and fluffy vanilla cupcakes with creamy buttercream frosting.',
      category: 'Cupcakes',
      salesCount: 90,
      discount: 15,
    ),
  ];

  // Getter to return a copy of the products list
  List<Product> get products => [..._products];

  // Getter to return best selling products
  List<Product> get bestSellingProducts {
    // Implement logic to return best selling products
    return _products.where((product) => product.salesCount > 100).toList();
  }

  // Getter to return discounted products
  List<Product> get discountedProducts {
    // Implement logic to return discounted products
    return _products.where((product) => product.discount != null).toList();
  }

  // Method to add a new product
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  // Method to update an existing product
  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  // Method to delete a product by its ID
  void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  // Method to get a product by its ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Getter to return a list of unique categories
  List<String> get categories => ['All', ..._products.map((p) => p.category).toSet()];

  // Method to get products by category
  List<Product> getProductsByCategory(String category) {
    return category == 'All'
        ? List.from(products)
        : _products.where((product) => product.category == category).toList();
  }
}