// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  String? userId;
  String? userToken;

  void getAuthData(String id, String token) {
    userId = id;
    userToken = token;
    notifyListeners();
  }

  Map _userData = {
    'identify': null,
    'name': null,
    'birthday': null,
    'email': null,
    'school': null,
    'schoolYear': null,
    'field': null,
    'password': null,
    'phoneNumber': null,
  };

  Map get items {
    return {..._userData};
  }

  Future<void> getUserData() async {
    final response = await http.get(
      Uri.parse(
        'https://next-gen-copy-84830-default-rtdb.firebaseio.com/$userId.json?auth=$userToken',
      ),
    );
    final responseData = json.decode(response.body) as Map;
    responseData.forEach((key, value) {
      _userData = value;
    });
    notifyListeners();
  }
}
