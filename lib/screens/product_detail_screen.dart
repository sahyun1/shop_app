import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  // const ProductDetailScreen({ Key? key }) : super(key: key);

  static const ROUTE_NAME = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final prodcutId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
    );
  }
}
