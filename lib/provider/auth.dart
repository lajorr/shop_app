import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app_4/models/http_exception.dart';

// key = AIzaSyDCFkO-Hx17OWWWAu7BrWFy0k7tlTzer-8

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? expired;

  bool get isAuth {
    return (token != null);
  }

  String? get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future _authenticate(String email, String password, String urlSegment) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDCFkO-Hx17OWWWAu7BrWFy0k7tlTzer-8');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogOut();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (expired != null) {
      expired!.cancel();
      expired = null;
    }

    final prefs = await SharedPreferences.getInstance();
    // this is will remove only userData
    // prefs.remove('userData');
    print(prefs.getString('userData'));
    prefs.clear(); // this will wipe all data in share Pref
    print('logedout');
    print(prefs.getString('userData'));
    notifyListeners();
  }

  void _autoLogOut() {
    if (expired != null) {
      expired!.cancel();
    }
    final expirySec = _expiryDate!.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: expirySec), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }
}
