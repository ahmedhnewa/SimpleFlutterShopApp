import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class CartModel {
  final String id;
  final String productId;
  final int quantity;

  CartModel({
    required this.id,
    required this.productId,
    required this.quantity,
  });

  Product findProductById(context) {
    final productsContainer = Provider.of<Products>(context, listen: false);
    return productsContainer.findById(productId);
  }
}

class Cart with ChangeNotifier {
  final Map<String, CartModel> _items = {};

  Map<String, CartModel> get items {
    return {..._items};
  }

  int get itemCount => _items.length;
  bool get isCartEmpty => _items.isEmpty;

  double totalAmount(context) {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.quantity * value.findProductById(context).price;
    });
    return total;
  }

  void addItem({required String productId, int quantity = 1}) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartModel(
          id: value.id,
          productId: value.productId,
          quantity: quantity + value.quantity,
        ),
      );
      return;
    }
    _items.putIfAbsent(
      productId,
      () => CartModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        quantity: quantity,
      ),
    );
    notifyListeners();
  }

  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId) || _items[productId] == null) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (value) => CartModel(
          id: value.id,
          productId: value.productId,
          quantity: value.quantity - 1,
        ),
      );
      notifyListeners();
      return;
    }

    deleteItem(productId);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
