// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> productList;
  final DateTime dateTime;
  OrderItem({
    required this.id,
    required this.amount,
    required this.productList,
    required this.dateTime,
  });
}

// https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/

class Order extends ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orderItems {
    return [..._orders];
  }

  final String? authToken;
  final String? userId;
  Order(this.authToken, this.userId);

  Future fetchOrder() async {
    print('fetiching order');
    final url = Uri.parse(
        'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> orderList = [];

    final fetchedOrders = json.decode(response.body) as Map<String, dynamic>?;
    if (fetchedOrders == null) {
      return;
    }
    fetchedOrders.forEach((orderId, orderData) {
      orderList.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          productList: (orderData['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e["quantity"],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(
            orderData['date'],
          ),
        ),
      );
      _orders = orderList.reversed.toList();
      notifyListeners();
    });
  }

  Future addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');

    final timeStamp = DateTime
        .now(); // to ensure the time is same for both local and in server
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'products': cartProducts
                .map(
                  (e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  },
                )
                .toList(),
            'date': timeStamp
                .toIso8601String(), // .toIso8601String() this makes it so that this object can later be transformed into a DateTime object
            // 'date': DateFormat.yMd().format(DateTime.now()),
          },
        ),
      );
      
        _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            productList: cartProducts,
            dateTime: timeStamp,
          ),
        );
      
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
