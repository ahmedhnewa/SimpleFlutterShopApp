import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/editProduct';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product product = Product(
    id: 'p4',
    title: 'A Pan',
    description: 'Prepare any meal you want.',
    price: 49.99,
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  );
  // Product product = Product(
  //   id: '',
  //   title: '',
  //   description: '',
  //   price: 0,
  //   imageUrl: '',
  // );
  var _isInit = true;
  var _isLoading = false;
  var _isEdit = false;

  Future<void> _sendForm() async {
    final validForm = _form.currentState?.validate() ?? false;
    if (!validForm) return;
    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });
    bool success = true;
    final productsContainer = Provider.of<Products>(context, listen: false);
    try {
      _isEdit
          ? await productsContainer.updateProduct(product)
          : await productsContainer.addProduct(product);
    } catch (e) {
      success = false;
      await showDialog(
        context: context,
        builder: (context) => buildErrorDialog(e),
      );
    }
    doneForm(success);
  }

  Widget buildErrorDialog(Object e) => AlertDialog(
        title:
            Text('Error while ${_isEdit ? 'updating' : 'adding'} the product'),
        content: Text('Somthing went wrong: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          )
        ],
      );

  void doneForm(bool success) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: success ? null : Theme.of(context).errorColor,
      content: Text(
        'Product has been ${success ? '' : 'not'} ${_isEdit ? 'Edited' : 'Added'}',
        style: TextStyle(
            color:
                success ? null : Theme.of(context).textTheme.bodyMedium?.color),
      ),
    ));
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final p = ModalRoute.of(context)?.settings.arguments as Product?;
      if (p != null) {
        product = p;
        _isEdit = true;
      }
      _imageUrlController.text = product.imageUrl;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _sendForm,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _sendForm,
            icon: const Icon(Icons.save),
          )
        ],
        title: Text('${_isEdit ? 'Edit' : 'Add'} Product'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Form(
              key: _form,
              autovalidateMode: AutovalidateMode.always,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    onSaved: (newValue) => product.title = newValue!,
                    initialValue: product.title,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Title',
                      // border: OutlineInputBorder(),
                      icon: Icon(Icons.title),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter the title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (newValue) =>
                        product.price = double.parse(newValue!),
                    initialValue: product.price.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: 'Price',
                      icon: Icon(Icons.price_check),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true)
                        return 'Please enter the price';
                      // try {
                      //   double.parse(value!);
                      // } catch (e) {
                      //   return 'Please enter a valid price';
                      // }
                      if (double.tryParse(value!) == null) {
                        return 'Please enter a valid price';
                      }

                      if (double.parse(value) <= 0) {
                        return 'Please enter a value greater than 0';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (newValue) => product.imageUrl = newValue!,
                    controller: _imageUrlController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter image url';
                      }
                      if (!value!.startsWith('http://') &&
                          !value.startsWith('https://')) {
                        return 'The url is not valid';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Image url',
                        hintText: 'Image url',
                        icon: GestureDetector(
                          child: const Icon(Icons.preview),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.black54,
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        )),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.url,
                    // onFieldSubmitted: (value) => _imageUrl = value,
                  ),
                  TextFormField(
                    initialValue: product.description,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter the description';
                      }
                      if (value!.length < 10) return 'Description is too short';
                      return null;
                    },
                    onSaved: (newValue) => product.description = newValue!,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Description',
                      icon: Icon(Icons.description),
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
    );
  }
}
