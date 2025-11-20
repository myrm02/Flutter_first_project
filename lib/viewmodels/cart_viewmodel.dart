// import 'package:flutter/src/widgets/framework.dart.';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity = 1;

  CartItem({required this.product});

  double getTotal() {
    return product.price * quantity;
  }
}

class CartViewModel extends ChangeNotifier {

  // État privé
  final List<CartItem> _items = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters publics (lecture seule)
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  // Chargement automatique à l'instanciation
  CartViewModel() {
    loadItems();
  }

  Future<List<CartItem>> loadItems() async {
    // Éviter les appels multiples simultanés
    if (_isLoading) return [];

    _setLoading(true);
    _clearError();

    try {
      return _items;
    } catch (error) {
      _setError('Impossible de charger les produits du panier');
      return _items;
    } finally {
      _setLoading(false);
    }
  }

  // Méthodes publiques pour manipuler le panier
  void add(Product product) {
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void modifyQuantity(CartItem item, int value) {
    item.quantity = value;
    notifyListeners();
  }

  List<String> getAvailableQuantityDropDownMenuOption() {
    List<String> quantityOptions = [];
    for (int i = 1; i <= 10; i++) {
      quantityOptions.add(i.toString());
    }
    return quantityOptions;
  }

  CartItem? getCartItemByProductId(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Méthodes privées pour gérer l'état
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}