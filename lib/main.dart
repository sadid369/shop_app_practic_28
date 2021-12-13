import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_practic_28/provider/auth.dart';
import 'package:shop_app_practic_28/provider/cart.dart';
import 'package:shop_app_practic_28/provider/order.dart';
import 'package:shop_app_practic_28/provider/products.dart';
import 'package:shop_app_practic_28/screen/auth_screen_my_own.dart';
import 'package:shop_app_practic_28/screen/cart_screen.dart';
import 'package:shop_app_practic_28/screen/edit_product_screen.dart';
import 'package:shop_app_practic_28/screen/order_screen.dart';
import 'package:shop_app_practic_28/screen/product_detail_screen.dart';
import 'package:shop_app_practic_28/screen/product_overview_screen.dart';
import 'package:shop_app_practic_28/screen/user_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', []),
          update: (context, auth, previousProduct) => Products(
              auth.token, previousProduct == null ? [] : previousProduct.item),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (context) => Order('', []),
          update: (context, auth, previousOrder) => Order(auth.token,
              previousOrder == null ? [] : previousOrder.orderItems),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen2(),
          routes: {
            ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
