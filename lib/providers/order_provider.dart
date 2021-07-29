import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order_item.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> retrieveOrders() async {
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        'orders.json');

    final response = await http.get(url);
    final responeBody = json.decode(response.body) as Map<String, dynamic>;
    if (responeBody != null) {
      return;
    }
    final List<OrderItem> fetchedList = [];
    responeBody.forEach((key, value) {
      fetchedList.add(OrderItem(
        key,
        value['amount'],
        (value['products'] as List<dynamic>)
            .map(
                (e) => CartItem(e['id'], e['title'], e['quantity'], e['price']))
            .toList(),
        DateTime.parse(value['dateTime']),
      ));
    });

    _orders = fetchedList;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> items, double total) async {
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        'orders.json');
    final timestamp = DateTime.now();

    final jsonObj = json.encode({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': items
          .map((e) => {
                'id': e.id,
                'title': e.title,
                'price': e.price,
                'quantity': e.qunatity
              })
          .toList()
    });
    final response = await http.post(url, body: jsonObj);
    _orders.insert(0,
        OrderItem(json.decode(response.body)['name'], total, items, timestamp));
    notifyListeners();
  }
}
