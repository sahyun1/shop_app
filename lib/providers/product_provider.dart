import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchItems() async {
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products.json');
    try {
      final response = await http.get(url);
      print(response.body);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData != null) {
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
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products.json');

    final jsonObj = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price
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
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products/$id.json');

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
    final url = Uri.https(
        'udemy-flutter-3bb04-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products/$id.json');
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
