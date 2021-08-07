import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart_provider.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({ Key? key }) : super(key: key);

  final String id;
  final String title;
  final String imageUrl;
  final double price;

  const ProductItem(this.id, this.title, this.imageUrl, this.price);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailScreen.ROUTE_NAME, arguments: id);
              // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              //   return ProductDetailScreen();
              // }));
            },
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(
                imageUrl,
              ),
              fit: BoxFit.cover,
            )),
        footer: GridTileBar(
          // leading: IconButton(
          //   icon: Icon(Icons.favorite),
          //   color: Theme.of(context).accentColor,
          //   onPressed: () {},
          // ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cartProvider.addItem(id, price, title);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added item to cart',
                  //textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    cartProvider.removeSingleQuantityItem(id);
                  },
                ),
              ));
            },
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
