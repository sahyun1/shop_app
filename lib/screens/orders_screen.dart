import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/order_provider.dart';
import 'package:flutter_complete_guide/widgets/drawer_widget.dart';
import 'package:flutter_complete_guide/widgets/order_list_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const PAGE_ROUTE = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).retrieveOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: DrawerWidget(),
      body: ListView.builder(
          itemCount: orderProvider.orders.length,
          itemBuilder: (ctx, i) => OrderListItem(orderProvider.orders[i])),
    );
  }
}
