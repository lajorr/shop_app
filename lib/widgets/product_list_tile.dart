// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/products_provider.dart';

import 'package:shop_app_4/screens/edit_product_screen.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.id,
  }) : super(key: key);

  final String title;
  final String imageUrl;
  final String id;

  Future onDelete(BuildContext context, ScaffoldMessengerState scaffold) async {
    try {
      await Provider.of<ProductsProvider>(context, listen: false)
          .deleteProduct(id);
    } catch (e) {
      // print(e);

      /// Using ScaffoldMessenger.of(context) or jst context in a Future object is not valid cz it clashes with whether the context is same or not as the widget refreshes or something sou to fix that ....
      scaffold.showSnackBar(
        const SnackBar(
          content: Text(
            'Deleting Failed',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              imageUrl,
            ),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName, arguments: id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => onDelete(context, scaffold),
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
