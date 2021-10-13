import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final authToken;
  final userId;
  Orders(this.authToken, this.userId, this._orders);

  Future<void> fetchOrder() async {
    final url =
        "https://shopapp-3da4a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final List<OrderItem> loadOrders = [];
    final extractData = json.decode(response.body) as Map<String, dynamic>;
    if (extractData == null) {
      return;
    }
    extractData.forEach((orderId, orderData) {
      loadOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData["amount"],
          dateTime: DateTime.parse(
            orderData["dateTime"],
          ),
          products: (orderData["products"] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item["id"],
                    title: item["title"],
                    price: item["price"],
                    quantity: item["quantity"]),
              )
              .toList(),
        ),
      );
    });
    _orders = loadOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final time = DateTime.now();
    final url =
        "https://shopapp-3da4a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "dateTime": time.toIso8601String(),
          "products": cartProduct
              .map((ca) => {
                    "id": ca.id,
                    "title": ca.title,
                    "price": ca.price,
                    "quantity": ca.quantity
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          dateTime: time,
          products: cartProduct),
    );
    notifyListeners();
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}
