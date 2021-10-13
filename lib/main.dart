import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/provider/auth.dart';
import 'package:flutter_application_1/app_2/provider/orders.dart';
import 'package:flutter_application_1/app_2/screen/auth_screen.dart';
import 'package:flutter_application_1/app_2/screen/cart_screen.dart';
import 'package:flutter_application_1/app_2/screen/edite_proudct_screen.dart';
import 'package:flutter_application_1/app_2/screen/splash_screen.dart';
import 'package:flutter_application_1/app_2/screen/user_products_screen.dart';
import 'package:flutter_application_1/app_2/screen/order_screen.dart';
import 'package:flutter_application_1/app_2/provider/cart.dart';
import 'package:flutter_application_1/app_2/screen/product_detail_screen.dart';
import 'package:flutter_application_1/app_2/provider/products.dart';
import 'package:provider/provider.dart';

import 'app_2/screen/prodect_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, product) => Products(
              auth.token, auth.userId, product == null ? [] : product.items),
          create: (context) => null,
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, orders) => Orders(
              auth.token, auth.userId, orders == null ? [] : orders.orders),
          create: (context) => null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.purple, accentColor: Colors.deepOrange),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditeProudctScreen.routName: (ctx) => EditeProudctScreen(),
            }),
      ),
    );
  }
}
