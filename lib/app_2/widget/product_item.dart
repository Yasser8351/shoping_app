import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/provider/auth.dart';
import 'package:flutter_application_1/app_2/provider/prodects.dart';
import 'package:flutter_application_1/app_2/screen/product_detail_screen.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final produect = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: produect.id);
          },
          child: Hero(
              tag: produect.id,
              child: produect.imageUrl == null
                  ? Image.network(
                      "https://miro.medium.com/max/880/0*H3jZONKqRuAAeHnG.jpg",
                      fit: BoxFit.cover)
                  : Image.network(produect.imageUrl, fit: BoxFit.cover)

              //child: FadeInImage(
              //placeholder: AssetImage("assets\images\product-placeholder.png"),
              // placeholder: null,
              //image: NetworkImage(
              //produect.imageUrl,
              //),
              //fit: BoxFit.cover,
              //),
              ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            "${produect.title}",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: produect.isFaverts
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                produect.toogleIsFaverts(auth.token, auth.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(produect.id, produect.title, produect.price);

                /////////////////////////////////////////////////////////////////////////////////////////////
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added Item to cart!"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Cancel Order",
                      onPressed: () {
                        cart.cancelOrder(produect.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
