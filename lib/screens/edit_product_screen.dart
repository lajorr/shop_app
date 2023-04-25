import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_4/provider/product.dart';
import 'package:shop_app_4/provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final urlController = TextEditingController();
  final imageFocusNode = FocusNode();

  var edittedProduct = Product(
    id: null,
    title: 'title',
    description: 'desc',
    price: 0,
    imageUrl: 'url',
  );

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    imageFocusNode.addListener(updateUrl);
    super.initState();
  }

  var isInit = true;
  var isLoading = false;
  var defaultValue = {
    'title': '',
    'id': null,
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        edittedProduct =
            Provider.of<ProductsProvider>(context).findById(productId);
        defaultValue = {
          'title': edittedProduct.title,
          'id': edittedProduct.id,
          'description': edittedProduct.description,
          'price': edittedProduct.price.toString(),
          'imageUrl': '',
        };
        urlController.text = edittedProduct.imageUrl;
      }
      isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageFocusNode.removeListener(updateUrl);
    urlController.dispose();
    imageFocusNode.dispose();
    super.dispose();
  }

  Future saveForm() async {
    final products = Provider.of<ProductsProvider>(context, listen: false);
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (edittedProduct.id != null) {
      try {
        await products.updateProducts(edittedProduct.id!, edittedProduct);
      } catch (e) {
        print(e);
      }
      // setState(() {
      //   isLoading = false;
      // });
      // Navigator.of(context).pop();
    } else {
      try {
        await products.addProducts(edittedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('ERROR!!!'),
            content: const Text('Something went wrong!!'),
            actions: [
              TextButton(
                child: const Text(
                  'Okay',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   // finally block is always executed
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void updateUrl() {
    if (!imageFocusNode.hasFocus) {
      if (urlController.text.isEmpty ||
          (!urlController.text.startsWith('http') &&
              !urlController.text.startsWith('https')) ||
          (!urlController.text.endsWith('jpg') &&
              !urlController.text.endsWith('jpeg') &&
              !urlController.text.endsWith('png'))) {
        return;
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
        ),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter a Value';
                            }
                            return null;
                          },
                          initialValue: defaultValue['title'] as String,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (newValue) {
                            edittedProduct = Product(
                              isFavorite: edittedProduct.isFavorite,
                              id: edittedProduct.id,
                              title: newValue!,
                              description: edittedProduct.description,
                              price: edittedProduct.price,
                              imageUrl: edittedProduct.imageUrl,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: defaultValue['price'],
                          decoration: const InputDecoration(
                            labelText: 'Price',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a value';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Enter a Valid Number';
                            }
                            final price = double.parse(value);
                            if (price <= 0) {
                              return 'Enter a number graeter than 0 ';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (newValue) {
                            edittedProduct = Product(
                              id: edittedProduct.id,
                              title: edittedProduct.title,
                              description: edittedProduct.description,
                              price: double.parse(newValue!),
                              imageUrl: edittedProduct.imageUrl,
                              isFavorite: edittedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: defaultValue['description'],
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          // textInputAction: TextInputAction.Description,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter a Description';
                            }
                            if (value.length < 10) {
                              return 'Enter at least 10 characters';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            edittedProduct = Product(
                              id: edittedProduct.id,
                              title: edittedProduct.title,
                              description: newValue!,
                              price: edittedProduct.price,
                              imageUrl: edittedProduct.imageUrl,
                              isFavorite: edittedProduct.isFavorite,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: urlController.text.isEmpty
                                    ? const Text('Empty')
                                    : FittedBox(
                                        child: Image.network(
                                          urlController.text,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: urlController,
                                  focusNode: imageFocusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Image Url',
                                  ),
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter a url';
                                    }
                                    if (!value.startsWith('http') &&
                                        !value.startsWith('https')) {
                                      return 'Enter a valid url';
                                    }
                                    if (!value.endsWith('jpg') &&
                                        !value.endsWith('jpeg') &&
                                        !value.endsWith('png')) {
                                      return 'Enter a valid url';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    edittedProduct = Product(
                                      id: edittedProduct.id,
                                      title: edittedProduct.title,
                                      description: edittedProduct.description,
                                      price: edittedProduct.price,
                                      imageUrl: newValue!,
                                      isFavorite: edittedProduct.isFavorite,
                                    );
                                  },
                                  onFieldSubmitted: (_) => saveForm(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
