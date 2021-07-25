import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> items, double total) {
    _orders.insert(
        0, OrderItem(DateTime.now().toString(), total, items, DateTime.now()));
    notifyListeners();
  }
}
