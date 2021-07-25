import 'package:flutter/material.dart';

class CartListItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  const CartListItem(this.id, this.price, this.quantity, this.title);

  // const CartListItem({ Key? key }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(child: Text('\$$price'))),
          ),
          title: Text(title),
          subtitle: Text('Total \$${price * quantity}'),
          trailing: Text('Quantity: $quantity'),
        ),
      ),
    );
  }
}
