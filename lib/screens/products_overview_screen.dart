import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer_widget.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favourite, All }

class ProductsOverviewScreen extends StatelessWidget {
  // const ProductsOverviewScreen({ Key? key }) : super(key: key);

  static const PAGE_ROUTE = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (val) => print(val),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Only Favourites'),
                      value: FilterOptions.Favourite,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    )
                  ]),
          Consumer<CartProvider>(
            builder: (_, cartProvider, child) =>
                Badge(child: child, value: cartProvider.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.ROUTE_NAME),
            ),
          )
        ],
      ),
      drawer: DrawerWidget(),
      body: ProductsGrid(),
    );
  }
}
