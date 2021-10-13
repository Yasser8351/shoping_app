import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  bool isFaverts;

  Product(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.price,
      @required this.description,
      this.isFaverts = false});

  void _setFavert(bool newFav) {
    isFaverts = newFav;
    notifyListeners();
  }

  Future<void> toogleIsFaverts(String token, String userId) async {
    final oldFavert = isFaverts;
    isFaverts = !isFaverts;
    notifyListeners();
    final url =
        "https://shopapp-3da4a-default-rtdb.firebaseio.com/products/userFaverts/$userId/$id.json?auth=$token";

    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFaverts,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavert(oldFavert);
      }
    } catch (error) {
      _setFavert(oldFavert);
    }
  }
}
