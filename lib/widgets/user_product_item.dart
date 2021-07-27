import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/add_edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  const UserProductItem(this.id, this.title, this.imageUrl);
  // const UserProductItem({ Key? key }) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                      AddEditProductScreen.ROUTE_NAME,
                      arguments: id);
                },
                icon: Icon(Icons.edit),
                color: Theme.of(context).accentColor),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ))
          ],
        ),
      ),
    );
  }
}
