import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({ Key? key }) : super(key: key);

  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
