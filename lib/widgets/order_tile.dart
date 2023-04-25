// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shop_app_4/main.dart';

import '../provider/order.dart';

class OrderTile extends StatefulWidget {
  const OrderTile({
    Key? key,
    required this.order,
  }) : super(key: key);
  final OrderItem order;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  var isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isExpanded
          ? min(widget.order.productList.length * 20.0 + 110, 200)
          : 90,
      child: Card(
        margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        elevation: 5,
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy  hh:mm').format(
                  widget.order.dateTime,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
              ),
            ),
            // if (isExpanded)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              // color: Colors.grey[100],
              height: isExpanded
                  ? min(widget.order.productList.length * 20.0 + 10, 100)
                  : 0,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: ListView(
                children: [
                  ...widget.order.productList
                      .map((prod) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    prod.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${prod.quantity}x \$${prod.price}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              )
                          // {
                          //   return Column(
                          //     children: [
                          //       ListTile(
                          //         title: Text(
                          //           prod.title,
                          //           style: const TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 18,
                          //           ),
                          //         ),
                          //         trailing: Text(
                          //           '${prod.quantity}x  \$${prod.price}',
                          //           style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.grey[600],
                          //             fontSize: 18,
                          //           ),
                          //         ),
                          //       ),
                          //       const Divider(thickness: 1),
                          //     ],
                          //   );
                          // }
                          )
                      .toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
