import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app_4/models/http_exception.dart';
import 'dart:convert';

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;

  ProductsProvider(this.authToken, this.userId);

  // ignore: prefer_final_fields
  List<Product> _items = [
    //   // this could be final???? but hudaina vanxa ta vid ma idk // this cant be final
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];

  List<Product> get items {
    return [
      ..._items
    ]; // this will make a copy of _items so that we can make changes to it without affecting the data source directlyz
  }

  List<Product> get favItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  // void showFavorites() {
  //   showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future addProducts(Product product) async {
    final url = Uri.parse(
      'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
            'creatorId': userId,
          },
        ),
      );
      // print(json.decode(response.body)['name']);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners(); // to notify changes in the data source so that data can be updated. without this u would have to refresh to see the changes
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future updateProducts(String id, Product product) async {
    final url = Uri.parse(
      'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken',
    );

    final itemIndex = _items.indexWhere((element) => element.id == id);
    if (itemIndex >= 0) {
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
            },
          ),
        );
        _items[itemIndex] = product;
      } catch (e) {
        print(e);
      }
    } else {
      print('error index not found');
    }
    notifyListeners();
  }

  /// server ma vako data is in json (Javascript Object Notation) format..
  /// souu to store data in server, u need to convert ur data into json first using json.encode
  /// and to extract data which is in json format, u need to convert it back to Map using json.decode
  /// now all the data fetched from the server is in Map<String, Map<String, object>> formatt
  /// but dart cant read nested Map formats sou we write it as Map<String, dynamic>

  Future fetchProducts([bool filterByUser = false]) async {
    final filteredString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : null;

    var url = Uri.parse(
      'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filteredString',
    );
    try {
      final response = await http.get(url);
      final List<Product> productsList = [];
      final fetchedProducts =
          json.decode(response.body) as Map<String, dynamic>;
      if (fetchedProducts == null) {
        return;
      }

      url = Uri.parse(
        'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken',
      );

      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);

      fetchedProducts.forEach(
        (prodId, prodData) {
          productsList.add(
            Product(
              id: prodId,
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              title: prodData['title'],
              isFavorite: favData == null ? false : favData[prodId] ?? false,
            ),
          );
        },
      );
      _items = productsList;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future deleteProduct(String id) async {
    final url = Uri.parse(
      'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken',
    );
    final existingProdId = _items.indexWhere((element) => element.id == id);
    Product? existingProd = _items.elementAt(existingProdId);

    // http.delete(url).then(
    //   (response) {
    //     if (response.statusCode > 400) // for catching errors
    //     {
    //       throw HttpException('ERROR Cant delete');
    //     }
    //     // print(response.statusCode);
    //     existingProd = null;
    //   },
    // ).catchError(
    //   (error) {
    //     print(error);
    //     _items.insert(existingProdId, existingProd!);
    //     notifyListeners();
    //   },
    // );

    _items.removeAt(existingProdId);
    notifyListeners();
    final response = await http.delete(url);
    // _items.removeWhere((element) => element.id == id);
    if (response.statusCode > 400) {
      _items.insert(existingProdId, existingProd);
      notifyListeners();
      throw HttpException('ERROR cant delete item');
    }
    existingProd = null;
  }
}
