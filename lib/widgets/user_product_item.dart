import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products.dart';
import '/screens/edit_product.dart';
import '/providers/product.dart' show Product;

class UserProductItem extends StatelessWidget {
  const UserProductItem(this.item, {super.key});

  final Product item;

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(item.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.imageUrl),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: item,
                ),
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).hintColor,
                ),
              ),
              IconButton(
                  onPressed: () async {
                    final errorColor = Theme.of(context).errorColor;
                    final textColor =
                        Theme.of(context).textTheme.bodyMedium?.color;
                    try {
                      await Provider.of<Products>(
                        context,
                        listen: false,
                      ).removeProduct(item.id);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Product has been deleted'),
                        ),
                      );
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          backgroundColor: errorColor,
                          content: Text(
                            'Product didn\'t deleted',
                            style: TextStyle(
                              color: textColor,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildErrorDialog(Object e, BuildContext context) => AlertDialog(
        title: const Text('Error while deleting the product'),
        content: Text('Somthing went wrong: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          )
        ],
      );
}
