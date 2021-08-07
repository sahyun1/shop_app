import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (token != null) {
      return _userId;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, url) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}),
      );

      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = json.decode(response.body)['idToken'];
      _userId = json.decode(response.body)['localId'];
      _expireDate = DateTime.now().add(Duration(
          seconds: int.parse(json.decode(response.body)['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String(),
        'token': _token
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA22YaICaE23DsqTLURqm-Eg66i0Wk2SdE');
    return _authenticate(email, password, url);
  }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA22YaICaE23DsqTLURqm-Eg66i0Wk2SdE');
    return _authenticate(email, password, url);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserdata =
          json.decode(prefs.getString('userData')) as Map<String, dynamic>;
      final expireDate = DateTime.parse(extractedUserdata['expireDate']);

      if (expireDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = extractedUserdata['token'];
      _expireDate = expireDate;
      _userId = extractedUserdata['userId'];
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _expireDate = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');

    notifyListeners();
  }
}
