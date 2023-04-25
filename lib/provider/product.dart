// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app_4/models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future toggleFavoriteStatus(String token, String userId) async {
    final url = Uri.parse(
      'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token',
    );
    var oldStatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    final response = await put(
      url,
      body: json.encode(
        isFavorite,
      ),
    );
    if (response.statusCode >= 400) {
      // print("error");
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('errorrrr');
    }
  }
}
