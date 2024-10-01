import 'package:flutter/foundation.dart';
import 'package:labaneta_sweet/models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => [..._favorites];

  void addToFavorites(Product product) {
    if (!_favorites.contains(product)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(Product product) {
    _favorites.remove(product);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }
}