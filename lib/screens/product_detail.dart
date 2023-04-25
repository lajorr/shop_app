import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/products_provider.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments
        as String; // we get id of selected product
    // this widget doesnt need to be rebuilt when sourse is modified souu we set listen to false
    final loadedProducts = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);
    // findById is the filter method

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     loadedProducts.title,
      //   ),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProducts.title),
              background: Hero(
                tag: loadedProducts.id!,
                child: Image.network(
                  loadedProducts.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '\$${loadedProducts.price}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    loadedProducts.description,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
        // child: Column(
        //   children: [
        //     Container(
        //       height: 300,
        //       width: double.infinity,
        //       child:
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
