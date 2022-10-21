import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

import '/providers/cart.dart';
import '/widgets/cart_item.dart';
import '/providers/orders.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) => Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20)),
                    const Spacer(),
                    // const SizedBox(width: 10),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount(context).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge
                              ?.color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: OrderButton(cart),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) =>
                  CartItem(cart.items.values.toList()[index]),
              itemCount: cart.itemCount,
            ))
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton(
    this.cart, {
    Key? key,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.isCartEmpty || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              final List<Product> products = [];
              final List<CartModel> cartItems =
                  widget.cart.items.values.toList();
              cartItems.forEach((element) {
                products.add(Provider.of<Products>(context, listen: false)
                    .findById(element.productId));
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                  cartItems,
                  widget.cart.totalAmount(context),
                );
                widget.cart.clear();
              } catch (e) {
                print(e);
              }
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text('Order Now'),
    );
  }
}
