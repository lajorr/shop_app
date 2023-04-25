// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import 'product_grid_tile.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(this.isFav, {super.key});

  final bool isFav;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final products = isFav ? productData.favItems : productData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          // this is better when using provide in list/grids
          // create: (context) => products[index],
          value: products[index],
          child: ProductGridTile(
            id: products[index].id!,
            // id: prod.id,
            // imgUrl: prod.imageUrl,D
            // title: prod.title,
          ),
        );
      },
    );
  }
}
