import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/screens/drawer_screen.dart';
import 'package:shop_app_4/widgets/product_list_tile.dart';

import '../provider/products_provider.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user-products';

  Future onRefresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Products',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: const DrawerScreen(),
      body: FutureBuilder(
        future: onRefresh(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => onRefresh(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, product, child) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: product.items.length,
                            itemBuilder: (context, index) {
                              return ProductListTile(
                                id: product.items[index].id!,
                                title: product.items[index].title,
                                imageUrl: product.items[index].imageUrl,
                              );
                            }),
                      ),
                    ),
                  ),
      ),
    );
  }
}
