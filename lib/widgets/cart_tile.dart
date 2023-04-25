// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class CartTile extends StatelessWidget {
  const CartTile({
    Key? key,
    required this.id,
    required this.productId,
    required this.price,
    required this.title,
    required this.quantity,
  }) : super(key: key);
  final String id;
  final String productId;
  final double price;
  final String title;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.all(8),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.delete,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are You Sure?'), 
                content: const Text(
                  'Do You want to remove this cart?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      'No',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      'Yes',
                    ),
                  ),
                ],
              );
            });
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge!
                            .color),
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              'Total: \$${price * quantity}',
            ),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
