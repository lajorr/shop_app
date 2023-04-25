import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/products_provider.dart';
import 'package:shop_app_4/screens/drawer_screen.dart';
import 'package:shop_app_4/widgets/badge.dart' as b;

import '../provider/cart.dart';
import '../widgets/product_grid.dart';
import 'cart_screen.dart';

enum FilterOption {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavoritesOnly = false;
  var isInit = true;
  var isLoading = false;

  @override
  void initState() {
    // Provider.of<ProductsProvider>(context).fetchProducts(); // anything that requires context doesnt work in init state
    ///alternative
    ///
    ///
    ///this works!!!
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<ProductsProvider>(context).fetchProducts();
    // });

    /// this is bullshit ok i did this cz i mistakenly deleted all the folders (including the main products folder)
    /// and now there is no folder named products in the database sou when it tries fetch data it throws error
    /// these lines of code is to create the required products folder cz for some reason u cant create a folder from the web??
    /// or i jst dont know how to create a folder .....

    // final url = Uri.parse(
    //   'https://shop-app-c9668-default-rtdb.asia-southeast1.firebasedatabase.app/products.json',
    // );
    // post(
    //   url,
    //   body: json.encode(
    //     {
    //       'title': 'asd',
    //         'description': 'asdasd',
    //         'price': 45,
    //         'imageUrl': 'asdasd',
    //         'isFavorite': false,
    //     },
    //   ),
    // );

    super.initState();
  }

  // another alternative
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts()
          .then((value) {
        setState(() {
          setState(() {
            isLoading = false;
          });
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Shop',
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption selectedFilter) {
              if (selectedFilter == FilterOption.favorites) {
                setState(() {
                  showFavoritesOnly = true;
                });
              } else {
                setState(() {
                  showFavoritesOnly = false;
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterOption.favorites,
                child: Text(
                  "Show Favorites",
                ),
              ),
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text(
                  "Show All",
                ),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return b.Badge(
                value: cart.itemCount.toString(),
                child: ch!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
          )
        ],
      ),
      drawer: const DrawerScreen(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavoritesOnly),
    );
  }
}
