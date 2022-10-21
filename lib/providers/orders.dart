import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import '../constants/api_urls.dart';

import '/providers/cart.dart';
// import '/providers/product.dart';

class OrderModel {
  String? id;
  final double amount;
  final List<CartModel> cartItems;
  final DateTime dateTime;

  OrderModel({
    this.id,
    required this.amount,
    required this.cartItems,
    required this.dateTime,
  });

  List<Map<String, dynamic>> convertCartItemsToMap() {
    final List<Map<String, dynamic>> items = [];
    for (var e in cartItems) {
      items.add({
        'id': e.id,
        'productId': e.productId,
        'quantity': e.quantity,
      });
    }
    return items;
  }

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'cartItems': convertCartItemsToMap(),
        'dateTime': dateTime.toIso8601String(),
      };

  static OrderModel fromMap(
          {required String id, required Map<String, dynamic> data}) =>
      OrderModel(
        id: id,
        amount: data['amount'],
        cartItems: (data['cartItems'] as List<dynamic>)
            .map((e) => CartModel(
                  id: id,
                  productId: e['productId'],
                  quantity: e['quantity'],
                ))
            .toList(),
        dateTime: DateTime.parse(data['dateTime']),
      );
}

class Orders with ChangeNotifier {
  final List<OrderModel> _orders;
  final String token;
  final String userId;

  List<OrderModel> get orders {
    return [..._orders];
  }

  int get itemCount => _orders.length;

  Orders(this.token, this.userId, this._orders) {
    // fetchOrders();
  }

  Future<void> fetchOrders() async {
    final url = '${getOrdersUrlOfUser(userId)}${attachTokenParameter(token)}';
    try {
      final response = await http.get(Uri.parse(url));
      _orders.clear();
      final body = json.decode(response.body) as Map<String, dynamic>?;
      if (body == null) return;
      if (body['error'] != null) throw HttpException(body['error'].toString());
      if (response.statusCode >= 400) throw HttpException(body.toString());

      body.forEach((orderId, value) {
        _orders.add(
          OrderModel.fromMap(id: orderId, data: value),
        );
      });

      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addOrder(
    List<CartModel> cartItems,
    double total,
  ) async {
    final url = getOrdersUrlOfUser(userId) + attachTokenParameter(token);
    print(url);
    final order = OrderModel(
      amount: total,
      cartItems: cartItems,
      dateTime: DateTime.now(),
    );
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(order.toMap()),
      );

      final body = json.decode(response.body) as Map<String, dynamic>;
      print(response.statusCode);

      if (response.statusCode >= 400) throw HttpException(body['error']);
      order.id = body['body'];

      _orders.insert(
        0,
        order,
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
