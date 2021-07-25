import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.qunatity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(existingItem.id, existingItem.title,
              existingItem.qunatity + 1, existingItem.price));
    } else {
      _items.putIfAbsent(productId,
          () => CartItem(DateTime.now().toString(), title, 1, price));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleQuantityItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].qunatity > 1) {
      _items.update(
          productId,
          (existingItem) => CartItem(existingItem.id, existingItem.title,
              existingItem.qunatity - 1, existingItem.price));
    } else {
      removeItem(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
