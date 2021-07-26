import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('MyShop')),
          ListTile(
            title: const Text('Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.PAGE_ROUTE),
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.PAGE_ROUTE),
          ),
          ListTile(
            title: const Text('Your Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.ROUTE_NAME),
          ),
        ],
      ),
    );
  }
}
