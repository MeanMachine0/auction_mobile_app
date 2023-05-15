import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:auction_mobile_app/models/account_model.dart';
import 'package:auction_mobile_app/models/item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String baseUrl = 'https://meanmachine0.pythonanywhere.com/api/';
  Future<List<String>?> login(String username, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? fcmToken = prefs.getString('fcmToken');
      Map<String, dynamic> data = {
        'username': username,
        'password': password,
        'fcmToken': fcmToken
      };
      var url = Uri.parse('${baseUrl}login/');
      var response = await http.post(url,
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String accountId = jsonResponse['userId'].toString();
        String token = jsonResponse['token'];
        List<String> IdToken = [accountId, token];
        return IdToken;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void logout(token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? fcmToken = prefs.getString('fcmToken');
      await prefs.clear();
      if (fcmToken != null) {
        await prefs.setString('fcmToken', fcmToken);
      }
      var url = Uri.parse('${baseUrl}logout/');
      await http.post(url, headers: {'Authorization': 'Token $token'});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> getUsername(int accountId, String token) async {
    try {
      var url = Uri.parse('${baseUrl}users/$accountId/');
      var response = await http.get(url,
          headers: {'username': 'true', 'Authorization': 'Token $token'});
      var jsonResponse = json.decode(response.body);
      return jsonResponse['username'];
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<AccountModel?> getAccount(int accountId) async {
    try {
      var url = Uri.parse('${baseUrl}accounts/$accountId/');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        AccountModel _model = AccountModel.fromJson(jsonResponse);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<ItemModel?> getItem(int itemId, String? token) async {
    try {
      var url = Uri.parse('${baseUrl}items/$itemId/');
      var response = await http.get(
        url,
        headers: token != null
            ? {
                'Authorization': 'Token $token',
              }
            : null,
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        ItemModel item = ItemModel.fromJson(jsonResponse);
        return item;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<List<ItemModel>?> getItems(
      bool ended,
      bool sold,
      bool searchBool,
      String search,
      String category,
      String condition,
      String sortBy,
      bool ascending) async {
    try {
      var url = Uri.parse('${baseUrl}items/');
      var response = await http.get(url, headers: {
        'ended': '$ended',
        'sold': '$sold',
        'searchBool': '$searchBool',
        'search': search,
        'category': category,
        'condition': condition,
        'sortBy': sortBy,
        'ascending': '$ascending',
      });
      if (response.statusCode == 200) {
        List<ItemModel> _model = itemsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> createItem(
    String name,
    double price,
    double postageCost,
    double bidIncrement,
    String condition,
    DateTime endDateTime,
    bool acceptsReturns,
    String description,
    String category,
    int sellerId,
    String token,
  ) async {
    try {
      var url = Uri.parse('${baseUrl}items/create/');
      Map<String, dynamic> data = {
        'name': name,
        'price': price,
        'postageCost': postageCost,
        'bidIncrement': bidIncrement,
        'condition': condition,
        'endDateTime': endDateTime.toIso8601String(),
        'acceptsReturns': acceptsReturns,
        'description': description,
        'category': category,
        'seller': sellerId,
      };
      var response = await http.post(url, body: json.encode(data), headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      });
      var decodedBody = json.decode(response.body);
      return decodedBody['itemId'];
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<String> submitBid(
      String bid, int itemId, int accountId, String token) async {
    double dBid = double.parse(bid);
    try {
      var url = Uri.parse('${baseUrl}items/$itemId/bid/');
      Map<String, dynamic> data = {
        'accountId': accountId,
        'bid': dBid,
      };
      var response = await http.post(url, body: json.encode(data), headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        int buyerId = body['buyer'];
        double price = double.parse(body['price']);
        double minBid = price + double.parse(body['bidIncrement']);
        if (price == dBid && buyerId == accountId) {
          return 'Bid of £$bid submitted.';
        } else if (dBid < minBid) {
          return 'Could not submit bid; bid < £$minBid.';
        }
        return 'Something went wrong - please try again in a moment.';
      }
      return 'Something went wrong - please try again in a moment.';
    } catch (e) {
      log(e.toString());
      return 'Something went wrong - please try again in a moment.';
    }
  }

  Future<List> getAccountItems(
    int accountId,
    String? token,
    bool ended,
  ) async {
    try {
      var url = Uri.parse('${baseUrl}accounts/$accountId/items/');
      var response = await http.get(
        url,
        headers: token != null
            ? {
                'ended': '$ended',
                'Authorization': 'Token $token',
              }
            : {'ended': '$ended'},
      );
      if (response.statusCode == 200) {
        try {
          List<ItemModel> _model = itemsModelFromJson(response.body);
          return _model;
        } catch (e) {
          var jsonResponse = json.decode(response.body);
          ItemModel _item = ItemModel.fromJson(jsonResponse);
          List<ItemModel> _model = [_item];
          return _model;
        }
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> amITheBuyer(int itemId, String? token, bool ended) async {
    if (token == null) {
      return false;
    }
    var url = Uri.parse('${baseUrl}amITheBuyer/$itemId/');
    var response =
        await http.get(url, headers: {'Authorization': 'Token $token'});
    var decodedResponse = json.decode(response.body);
    bool IAmTheBuyer = decodedResponse['IAmTheBuyer'];
    return IAmTheBuyer;
  }

  Future<List> getItemsBidOnByMe(
      int accountId, String token, bool ended) async {
    try {
      var url = Uri.parse('${baseUrl}accountBids/$accountId/');
      var response = await http.get(
        url,
        headers: {
          'ended': '$ended',
          'Authorization': 'Token $token',
        },
      );
      if (response.statusCode == 200) {
        try {
          List<ItemModel> _model = itemsModelFromJson(response.body);
          return _model;
        } catch (e) {
          var jsonResponse = json.decode(response.body);
          ItemModel _item = ItemModel.fromJson(jsonResponse);
          List<ItemModel> _model = [_item];
          return _model;
        }
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }
}
