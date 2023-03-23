import 'dart:io';

class ApiConstants {
  static String baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api/'
      : 'http://127.0.0.1:8000/api/';
  static String authTokenEndpoint = 'authToken/';
  static String usersEndpoint = 'users/';
  static String accountsEndpoint = 'accounts/';
  static String itemsEndpoint = 'items/';
  static String endedItemsEndpoint = 'endedItems/';
  static String loginEndpoint = 'login/';
}
