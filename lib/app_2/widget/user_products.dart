import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/provider/products.dart';
import 'package:flutter_application_1/app_2/screen/edite_proudct_screen.dart';
import 'package:provider/provider.dart';

class UserProducts extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProducts(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditeProudctScreen.routName, arguments: id);
                }),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("delete product"),
                      content: Text("are you wont delete this product?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Provider.of<Products>(context, listen: false)
                                .delteProduct(id);
                            Navigator.of(context).pop();
                          },
                          child: Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No"),
                        )
                      ],
                    ),
                  );
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content:
                        Text("deleting failed!", textAlign: TextAlign.center),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
