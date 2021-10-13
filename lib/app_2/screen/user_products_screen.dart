import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/provider/products.dart';
import 'package:flutter_application_1/app_2/screen/edite_proudct_screen.dart';
import 'package:flutter_application_1/app_2/widget/app_drawer.dart';
import 'package:flutter_application_1/app_2/widget/no_internet.dart';
import 'package:flutter_application_1/app_2/widget/user_products.dart';
import 'package:provider/provider.dart';

//UserProductsScreen
class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-product";
  const UserProductsScreen({Key key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditeProudctScreen.routName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (context, index) => Column(
                                  children: [
                                    UserProducts(
                                      productData.items[index].id,
                                      productData.items[index].title,
                                      productData.items[index].imageUrl,
                                    ),
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
