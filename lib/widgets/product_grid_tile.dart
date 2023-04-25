// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/auth.dart';

import 'package:shop_app_4/provider/cart.dart';
import 'package:shop_app_4/screens/product_detail.dart';

import '../provider/product.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cartContainer = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context);

    final scaffold = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading:
              //  Consumer<Product>(
              //   builder: (_, product, __) =>
              // using '_' cz we dont need context and child here
              // if we dont provide parameters it uses value from the parent class
              IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () async {
              try {
                await product.toggleFavoriteStatus(
                    authData.token!, authData.userId!);
              } catch (e) {
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Cant Change Status',
                    ),
                  ),
                );
              }
            },
          ),
          // ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              cartContainer.addItems(product.id!, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${product.title} Added to Cart',
                  ),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cartContainer.removeSingleItem(product.id!);
                      }),
                ),
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.routeName, arguments: product.id!);
          },
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder: const AssetImage('assets/image/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
