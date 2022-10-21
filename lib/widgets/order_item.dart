import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {super.key});

  final OrderModel order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height:
          _expanded ? min(widget.order.cartItems.length * 20 + 180, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() {
                  _expanded = !_expanded;
                }),
              ),
            ),
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
              height: _expanded
                  ? min(widget.order.cartItems.length * 20 + 100, 100)
                  : 0,
              duration: const Duration(milliseconds: 200),
              child: ListView(
                children: widget.order.cartItems.asMap().entries.map((e) {
                  final product = productsContainer.findById(e.value.productId);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.order.cartItems[e.key].quantity}x \$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
