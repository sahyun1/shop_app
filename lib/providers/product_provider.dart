import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/http_exception.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  final String _token;
  final String _userId;

  ProductProvider(this._token, this._items, this._userId);

  Future<void> fetchItems([bool filterByUser = false]) async {
    // final url = Uri.https(
    //     'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
    //     'products.json?auth=$_token');
    var _params = <String, String>{
      'auth': _token,
    };
    if (filterByUser) {
      _params = <String, String>{
        'auth': _token,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(_userId),
      };
    }

    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json',
        _params);

    try {
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode == 400) {
        throw HttpException('bad request 400');
      }
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      final List<Product> fetchedItems = [];
      if (extractData != null) {
        extractData.forEach((key, value) {
          fetchedItems.add(
            Product(
              id: key,
              description: value['description'],
              imageUrl: value['imageUrl'],
              price: value['price'],
              title: value['title'],
            ),
          );
        });

        _items = fetchedItems;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(Product product) async {
    // final url = Uri.https(
    //     'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
    //     'products.json');

    final _params = <String, String>{'auth': _token};
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json',
        _params);

    final jsonObj = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'creatorId': _userId,
    });

    try {
      final response = await http.post(url, body: jsonObj);
      print(json.decode(response.body));

      _items.add(Product(
        description: product.description,
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      ));
      notifyListeners();
    } catch (error) {
      print('this is error from product_provider' + error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final _params = <String, String>{'auth': _token};
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json',
        _params);

    final jsonObj = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price
    });

    await http.patch(url, body: jsonObj);

    final index = _items.indexWhere((element) => element.id == id);
    _items[index] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final _params = <String, String>{'auth': _token};
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products/$id.json',
        _params);

    await http.delete(url);
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.isNotEmpty
        ? _items.firstWhere((element) => element.id == id)
        : null;
  }
}
