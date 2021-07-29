import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:flutter_complete_guide/widgets/drawer_widget.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import 'add_edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const ROUTE_NAME = '/user-products';
  // const UserProductsScreen({ Key? key }) : super(key: key);
//

  Future<void> _getLatestList(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(AddEditProductScreen.ROUTE_NAME),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _getLatestList(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productProvider.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  productProvider.items[i].id,
                  productProvider.items[i].title,
                  productProvider.items[i].imageUrl,
                ),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
