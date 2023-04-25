import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/order.dart';
import 'package:shop_app_4/screens/drawer_screen.dart';
import 'package:shop_app_4/widgets/order_tile.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future orderFuture;

  Future obtainFuture() {
    return Provider.of<Order>(context, listen: false).fetchOrder();
  }

  @override
  void initState() {
    // initstate ma garyo vane ekchoti matra future obtain hunxa incase the widget needs to rebuild(in our case this widget doesnt rebuild.
    // )
    orderFuture = obtainFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
        ),
      ),
      drawer: const DrawerScreen(),
      body: FutureBuilder(
        future: orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('has error'),
              );
            } else {
              return Consumer<Order>(builder: (ctx, order, child) {
                return ListView.builder(
                  itemCount: order.orderItems.length,
                  itemBuilder: (context, i) {
                    return OrderTile(
                      order: order.orderItems[i],
                    );
                  },
                );
              });
            }
          }
        },
      ),
    );
  }
}
