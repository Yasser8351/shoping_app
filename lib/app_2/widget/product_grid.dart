import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/widget/product_item.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ProductGrid extends StatelessWidget {
  final bool show;
  ProductGrid(this.show);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = show ? productData.faverItem : productData.items;

    return Scaffold(
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
        // itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //   value: products[index],
        //   child: ProductItem(),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        ),
      ),
    );
  }
}
