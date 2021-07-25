import 'cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> orderedProducts;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.orderedProducts, this.dateTime);
}
