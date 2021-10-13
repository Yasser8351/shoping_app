import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/model/http_exeption.dart';
import 'package:flutter_application_1/app_2/provider/prodects.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final authToken;
  final userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  // _incrementCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int counter = (prefs.getInt('counter') ?? 0) + 1;
  //   print('Pressed $counter times.');
  //   await prefs.setInt('counter', counter);
  // }

  List<Product> get faverItem {
    return _items.where((prod) => prod.isFaverts).toList();
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    try {
      var url =
          "https://shopapp-3da4a-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString";

      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url =
          "https://shopapp-3da4a-default-rtdb.firebaseio.com/products/userFaverts/$userId.json?auth=$authToken";

      final faverResponse = await http.get(url);
      final faverData = json.decode(faverResponse.body);
      final List<Product> loadedProducts = [];
      extractData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
                id: prodId,
                title: prodData["title"],
                description: prodData["description"],
                imageUrl: prodData["imageUrl"],
                price: prodData["price"],
                isFaverts:
                    faverData == null ? false : faverData[prodId] ?? false),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product pro) async {
    //add
    final url =
        "https://shopapp-3da4a-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      var response = await http.post(
        url,
        body: json.encode({
          "title": pro.title,
          "description": pro.description,
          "price": pro.price,
          "imageUrl": pro.imageUrl,
          "isFaverts": pro.isFaverts,
          "creatorId": userId
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        title: pro.title,
        imageUrl: pro.imageUrl,
        price: pro.price,
        description: pro.description,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://shopapp-3da4a-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
      http.patch(
        url,
        body: json.encode(
          {
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("");
    }
  }

  void delteProduct(String id) async {
    final url =
        "https://shopapp-3da4a-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final existingIndex = _items.indexWhere((element) => element.id == id);
    var existing = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException("coud not delete product");
    }
    existing = null;
    // .catchError((error) {
    //   _items.insert(existingIndex, existing);
    //   notifyListeners();
    // },
    // );
    // _items.removeAt(existingIndex);
    // notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
