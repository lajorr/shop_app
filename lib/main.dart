import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/auth.dart';
import 'package:shop_app_4/provider/cart.dart';
import 'package:shop_app_4/provider/order.dart';
// import 'package:shop_app_4/provider/product.dart';
import 'package:shop_app_4/provider/products_provider.dart';
import 'package:shop_app_4/screens/cart_screen.dart';
import 'package:shop_app_4/screens/edit_product_screen.dart';
import 'package:shop_app_4/screens/orders_screen.dart';
import 'package:shop_app_4/screens/product_detail.dart';
import 'package:shop_app_4/screens/product_overview_screen.dart';
import 'package:shop_app_4/screens/spash_screen.dart';
import 'package:shop_app_4/screens/user_auth_screen.dart';
import 'package:shop_app_4/screens/user_products_screen.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (context) => ProductsProvider('', ''),

            // here value == auth
            update: (context, value, previous) => ProductsProvider(
              value.token,
              
              value.userId,
            ),
          ),
          // ChangeNotifierProvider(create: (context) => ProductsProvider()),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (context) => Order(null, null),
            update: (context, value, previous) => Order(
              value.token,
              value.userId,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const UserAuthScreen(),
                  ),
            routes: {
              ProductDetail.routeName: (context) => const ProductDetail(),
              CartScreen.routeName: (context) => const CartScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              // UserAuthScreen.routeName: (context) => const UserAuthScreen(),
            },
          ),
        ));
  }
}
