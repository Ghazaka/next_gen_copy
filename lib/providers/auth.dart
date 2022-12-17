// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/http_exception.dart';

const apiKey = 'AIzaSyCsejXKsUClEQ7eIACXQOyVe42ZsJN5BEA';

class Auth with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null && _userId != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey',
        ),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData['expiresIn']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
      _exchangeToken();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return;
    }
    final extractedUserData = json.decode(
      prefs.getString('userData')!,
    ) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(
      extractedUserData['expiryDate'] as String,
    );
    if (expiryDate.isBefore(DateTime.now())) {
      return;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _exchangeToken();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> resetPassword(String email) async {
    http.post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey',
      ),
      body: json.encode({
        'requestType': 'PASSWORD_RESET',
        'email': email,
      }),
    );
  }

  void _exchangeToken() {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpiry - 60),
      () async {
        try {
          final response = await http.post(
            Uri.parse(
              'https://securetoken.googleapis.com/v1/token?key=$apiKey',
            ),
            body: json.encode({
              'grant_type': 'refresh_token',
              'refresh_token': _refreshToken,
            }),
          );
          final responseData = json.decode(response.body);
          if (responseData['error'] != null) {
            throw HttpException(responseData['error']['message']);
          }
          _token = responseData['idToken'];
          _userId = responseData['user_id'];
          _expiryDate = DateTime.now().add(
            Duration(
              seconds: int.parse(responseData['expires_in']),
            ),
          );
          _refreshToken = responseData['refresh_token'];
          final userData = json.encode({
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate!.toIso8601String(),
          });
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('userData', userData);
          notifyListeners();
        } catch (e) {
          rethrow;
        }
      },
    );
  }
}
