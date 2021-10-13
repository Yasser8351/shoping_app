import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/provider/orders.dart';
import 'package:flutter_application_1/app_2/widget/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widget/order_items.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/order";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchOrder();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) =>
                  OrderItems(orderData.orders[index]),
            ),
    );
  }
}
// orderData.orders.length == 0
//           ? Padding(
//               padding: EdgeInsets.symmetric(vertical: 150),
//               child: Center(
//                 child: Text("No orders yet, plase add some!"),
//               ),
//             )
//           : 