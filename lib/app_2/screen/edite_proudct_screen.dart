import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/app_2/provider/prodects.dart';
import 'package:flutter_application_1/app_2/provider/products.dart';
import 'package:provider/provider.dart';

class EditeProudctScreen extends StatefulWidget {
  static const routName = "edit-proudect";
  const EditeProudctScreen({Key key}) : super(key: key);

  @override
  _EditeProudctScreenState createState() => _EditeProudctScreenState();
}

class _EditeProudctScreenState extends State<EditeProudctScreen> {
  final _priceFocus = FocusNode();
  final _discriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editingProduct =
      Product(id: null, title: "", price: 0, description: "", imageUrl: "");
  var _initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": ""
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editingProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          "title": _editingProduct.title,
          "price": _editingProduct.price.toString(),
          "description": _editingProduct.description,
          "imageUrl": ""
        };
        _imageController.text = _editingProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_updateImageUrl);
    _priceFocus.dispose();
    _discriptionFocus.dispose();
    _imageUrlFocus.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      if (!_imageController.text.startsWith("http") &&
          !_imageController.text.startsWith("https")) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return null;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editingProduct.id != null) {
      //Provider.of<Products>(context, listen: false).addProduct(_editingProduct);
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editingProduct.id, _editingProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editingProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An error occurred!"),
            content: Text("Something wrong"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit product"),
        actions: [
          IconButton(
              icon: (Icon(Icons.save)),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues["title"],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the title";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          isFaverts: _editingProduct.isFaverts,
                          title: value,
                          imageUrl: _editingProduct.imageUrl,
                          price: _editingProduct.price,
                          description: _editingProduct.description,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["price"],
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_discriptionFocus);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the price";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please enter the valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please enter a number greater than zero";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          isFaverts: _editingProduct.isFaverts,
                          title: _editingProduct.title,
                          imageUrl: _editingProduct.imageUrl,
                          price: double.parse(value),
                          description: _editingProduct.description,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues["description"],
                      decoration: InputDecoration(labelText: "Discription"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _discriptionFocus,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter the discription";
                        }
                        if (value.length < 5) {
                          return "Please enter character grate than 5";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editingProduct = Product(
                          id: _editingProduct.id,
                          isFaverts: _editingProduct.isFaverts,
                          title: _editingProduct.title,
                          imageUrl: _editingProduct.imageUrl,
                          price: _editingProduct.price,
                          description: value,
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageController.text.isEmpty
                              ? Center(child: Text("Enter a URL"))
                              : FittedBox(
                                  child: Image.network(_imageController.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageController,
                            decoration: InputDecoration(labelText: "Image url"),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocus,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter the image url";
                              }
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https")) {
                                return "Please enter the valid image url";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editingProduct = Product(
                                id: _editingProduct.id,
                                isFaverts: _editingProduct.isFaverts,
                                title: _editingProduct.title,
                                imageUrl: value,
                                price: _editingProduct.price,
                                description: _editingProduct.description,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
