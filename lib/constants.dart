import 'dart:io';
import 'package:flutter/material.dart';

class ApiConstants {
  static String baseUrl = Platform.isAndroid
      ? 'https://2000-90-251-175-128.eu.ngrok.io/api/'
      : 'http://127.0.0.1:8000/api/';
  static String usersEndpoint = 'users/';
  static String accountsEndpoint = 'accounts/';
  static String itemsEndpoint = 'items/';
  static String endedItemsEndpoint = 'endedItems/';
  static String loginEndpoint = 'login/';
  static String logoutEndpoint = 'logout/';
  static String createItemEndpoint = '${itemsEndpoint}create/';
  static String bidEndpoint = 'bid/';
}

class Colours {
  static const lightBlue = Color.fromARGB(255, 173, 216, 230);
  static const darkGray = Color.fromARGB(255, 84, 84, 84);
  static const deepGray = Color.fromARGB(255, 56, 56, 56);
  static const dimGray = Color.fromARGB(255, 112, 112, 112);
  static const lightGray = Color.fromARGB(255, 224, 224, 224);
  static const amber = Colors.amber;
  static const black = Colors.black;
  static const red = Color.fromARGB(255, 255, 0, 0);
}

class Regexes {
  static var money = RegExp(r'^\d{0,7}\.?\d{0,2}');
}
