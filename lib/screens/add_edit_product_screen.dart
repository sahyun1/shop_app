import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/product.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:provider/provider.dart';

class AddEditProductScreen extends StatefulWidget {
  // const AddEditProductScreen({ Key? key }) : super(key: key);
  static const ROUTE_NAME = '/add-edit-product';

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: null, title: null, description: null, price: null, imageUrl: null);
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        isLoading = true;
      });

      if (_editedProduct.id != null) {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        try {
          await Provider.of<ProductProvider>(context, listen: false)
              .addItem(_editedProduct);
        } catch (error) {
          showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('error'),
                  content: Text(
                    error.toString(),
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('ok'))
                  ],
                );
              });
        }
        //  finally {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   Navigator.pop(context);
        // }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                            labelText: 'Title',
                            errorStyle: TextStyle(fontSize: 12)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.length < 2) {
                            return 'Please enter more than 2 cha';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        }),
                    TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                          );
                        }),
                    TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            description: value,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                          );
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) => _saveForm(),
                              onSaved: (value) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
