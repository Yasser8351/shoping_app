import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_2/model/http_exeption.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authentication(
      String email, String pass, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyD8jBVnYPVlnie4PlqXPKT820IGhRn9ipA";
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": pass,
            "returnSecureToken": true,
          }));
      final responseDate = json.decode(response.body);
      if (responseDate["error"] != null) {
        throw HttpException(responseDate["error"]["message"]);
      }
      _token = responseDate["idToken"];
      _userId = responseDate["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseDate["expiresIn"])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) {
    return _authentication(email, password, "accounts:signUp");
  }

  Future<void> login(String email, String password) {
    return _authentication(email, password, "accounts:signInWithPassword");
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
