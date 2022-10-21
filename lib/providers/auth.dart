import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/models/http_exception.dart';
import '../constants/api_urls.dart' as constants;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth => token != null;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId => _userId ?? '';

  Future<void> authenticate(String email, String password, bool signIn) async {
    try {
      final response = await http.post(
        signIn ? constants.signInUrl : constants.signUpUrl,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final body = json.decode(response.body);
      print(body);
      if (body['error'] != null) throw HttpException(body['error']['message']);
      _token = body['idToken'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(
          body['expiresIn'],
        ),
      ));
      autoLogout();
      notifyListeners();
      final sharedPreferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expiryDate?.toIso8601String(),
      });
      sharedPreferences.setString('userData', userData);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final userData = json.decode(prefs.getString('userData')!);
    final expiryDate = DateTime.parse(userData['expiryDate']!);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, false);
  }

  Future<void> signin(String email, password) async {
    return authenticate(email, password, true);
  }

  Future<void> logout() async {
    _token = null;
    cancelTimer();
    _expiryDate = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void cancelTimer() {
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
  }

  void autoLogout() {
    cancelTimer();
    final expiryInSeconds = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryInSeconds), logout);
  }
}
