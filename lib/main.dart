import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth_provider.dart';
import 'package:flutter_complete_guide/screens/add_edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/cart_screen.dart';
import 'package:provider/provider.dart';
import '/screens/product_detail_screen.dart';
import 'providers/product_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
              create: (_) => ProductProvider(null, [], null),
              update: (ctx, auth, previous) => ProductProvider(auth.token,
                  previous.items == null ? [] : previous.items, auth.userId)),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
              create: (_) => OrderProvider(null, [], null),
              update: (ctx, auth, previous) => OrderProvider(auth.token,
                  previous.orders == null ? [] : previous.orders, auth.userId)),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              // inputDecorationTheme: inputDecorationTheme(),
              fontFamily: 'Lato',
            ),
            home: authData.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.ROUTE_NAME: (ctx) => ProductDetailScreen(),
              CartScreen.ROUTE_NAME: (ctx) => CartScreen(),
              OrdersScreen.PAGE_ROUTE: (ctx) => OrdersScreen(),
              UserProductsScreen.ROUTE_NAME: (ctx) => UserProductsScreen(),
              AddEditProductScreen.ROUTE_NAME: (ctx) => AddEditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen()
            },
          ),
        ));
  }

  InputDecorationTheme inputDecorationTheme() {
    var outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: Color(0xFF757575)),
        gapPadding: 10);
    var errorlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: Colors.red),
        gapPadding: 10);
    return InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: errorlineInputBorder,
        focusedErrorBorder: errorlineInputBorder);
  }
}
