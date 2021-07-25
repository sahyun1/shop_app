import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/order_provider.dart';
import 'package:flutter_complete_guide/widgets/cart_list_item.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  static const ROUTE_NAME = '/cart-screen';
  // const CartScreen({ Key? key }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrder(cartProvider.items.values.toList(),
                              cartProvider.totalAmount);
                      cartProvider.clearCart();
                    },
                    child: Text(
                      'Order Now',
                    ),
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartListItem(
                  cartProvider.items.values.toList()[i].id,
                  cartProvider.items.keys.toList()[i],
                  cartProvider.items.values.toList()[i].price,
                  cartProvider.items.values.toList()[i].qunatity,
                  cartProvider.items.values.toList()[i].title),
              itemCount: cartProvider.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
