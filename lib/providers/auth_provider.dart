import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/http_exception.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime expireDate;
  String _userId;

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
}
