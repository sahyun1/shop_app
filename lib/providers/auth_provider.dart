import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime expireDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA22YaICaE23DsqTLURqm-Eg66i0Wk2SdE');

    final response = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    print(json.decode(response.body));
  }
}
