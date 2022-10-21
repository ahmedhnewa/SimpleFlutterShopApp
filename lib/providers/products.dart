import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/providers/product.dart';
import '/models/http_exception.dart';
import '../constants/api_urls.dart';

class Products with ChangeNotifier {
  static const baseUrl =
      'https://demoproject-970fa-default-rtdb.europe-west1.firebasedatabase.app';
  static const productsUrl = '$baseUrl/products';
  final List<Product> _items;

  Products(this.token, this.userId, this._items) {
    // fetchProducts();
  }

  final String token;
  final String userId;

  Future<void> fetchProducts([bool filterByUser = false]) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$productsUrl.json${attachTokenParameter(token)}${filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : ''}'),
      );
      // if (response.body == null || response.statusCode != 200) {
      //   print('error ${response.statusCode} ${response.body}');
      //   return;
      // }
      _items.clear();
      final body = json.decode(response.body) as Map<String, dynamic>?;
      if (body == null) return;
      final favroitesResponse = await http.get(
          Uri.parse(getUserFavoritesUrl(userId) + attachTokenParameter(token)));
      final favoritesBody = json.decode(favroitesResponse.body);
      body.forEach((productId, value) {
        final item = value as Map<String, dynamic>;
        final product = Product.fromMap(
          id: productId,
          data: item,
          isFavorite: favoritesBody[productId] ?? false,
        );
        _items.add(product);
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<Product> get items => [..._items];

  int get itemCount => _items.length;

  List<Product> get favoritesItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) =>
      _items.firstWhere((element) => element.id == id);

  Future<void> addProduct(Product item) async {
    try {
      final response = await http.post(
        Uri.parse('$productsUrl.json${attachTokenParameter(token)}'),
        body: json.encode(item.toMap(userId)),
      );
      // if (response.statusCode != 200) return Future.value(response.body);

      final body = json.decode(response.body) as Map<String, dynamic>;
      item.id = body['name'];
      _items.add(item);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product item) async {
    final index = _items.indexWhere((element) => element.id == item.id);
    if (!(index >= 0)) return;
    final url = getProductUrl(item.id) + attachTokenParameter(token);
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode(item.toMap(userId)));
      if (response.statusCode != 200) throw HttpException(response.body);
      _items[index] = item;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeProduct(String productId) async {
    final index = _items.indexWhere((element) => element.id == productId);
    Product? product = _items[index];
    _items.removeAt(index);
    notifyListeners();

    final url = getProductUrl(productId) + attachTokenParameter(token);
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode >= 400) throw HttpException(response.body);
      product = null;
    } catch (e) {
      _items.insert(index, product!);
      notifyListeners();
      rethrow;
    }
  }
}
