import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem(this.cart, {super.key});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    final product = cart.findProductById(context);
    return Dismissible(
      key: ValueKey(cart.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          size: 40,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Removing cart item'),
            content: const Text('Do you want to remove the item?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'))
            ],
          ),
        );
        // return Future.value(false);
      },
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).deleteItem(cart.productId),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 30,
              child: FittedBox(
                child: Text('\$${product.price}'),
              ),
            ),
            title: Text(product.title),
            subtitle: Text('Total: \$${product.price * cart.quantity}'),
            trailing: Text('${cart.quantity} x'),
          ),
        ),
      ),
    );
  }
}
