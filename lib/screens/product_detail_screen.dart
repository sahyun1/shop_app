import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // const ProductDetailScreen({ Key? key }) : super(key: key);

  static const ROUTE_NAME = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final prodcutId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductProvider>(context, listen: false)
        .findById(prodcutId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
