import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/auth.dart';
import 'package:shop_app_4/screens/orders_screen.dart';
import 'package:shop_app_4/screens/user_products_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.amber,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 150,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello, User',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'Shop',
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              title: Text(
                'Your Orders',
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            ListTile(
              title: Text(
                'Your Products',
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: 25),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: 25),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                // Navigator.of(context)
                //     .pushReplacementNamed(UserProductsScreen.routeName);

                Provider.of<Auth>(context, listen: false).logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
