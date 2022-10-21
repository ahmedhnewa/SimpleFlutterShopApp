import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '/models/http_exception.dart';

import '../constants/api_urls.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;

  bool isFavorite;

  void _setFavoriteValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    _setFavoriteValue(!isFavorite);
    final url = getUserFavoriteUrl(productId: id, userId: userId) +
        attachTokenParameter(token);
    try {
      final response =
          await http.put(Uri.parse(url), body: json.encode(isFavorite));
      if (response.statusCode >= 400) throw HttpException(response.body);

      // print(response.body);
    } catch (e) {
      _setFavoriteValue(!isFavorite);
      print(e);
    }
  }

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap(String userId) => {
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'creatorId': userId,
      };

  static Product fromMap(
          {required String id,
          required Map<String, dynamic> data,
          required bool isFavorite}) =>
      Product(
        id: id,
        title: data['title'],
        description: data['description'],
        price: data['price'],
        imageUrl: data['imageUrl'],
        isFavorite: isFavorite,
      );
}
