import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:auction_mobile_app/models/user_model.dart';
import 'package:auction_mobile_app/models/accounts_model.dart';
import 'package:auction_mobile_app/models/items_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static String baseUrl = 'http://10.0.2.2:8000/api/';
  Future<List<String>?> login(String username, String password) async {
    try {
      Map<String, dynamic> data = {'username': username, 'password': password};
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
      await prefs.clear();
      var url = Uri.parse('${baseUrl}logout/');
      await http.post(url, headers: {'Authorization': 'Token $token'});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<AccountsModel?> getAccount(int accountId) async {
    try {
      var url = Uri.parse('${baseUrl}accounts/$accountId/');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        AccountsModel _model = AccountsModel.fromJson(jsonResponse);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<ItemsModel?> getItem(int itemId, String? token) async {
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
        ItemsModel item = ItemsModel.fromJson(jsonResponse);
        return item;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<List<ItemsModel>?> getItems(bool ended, bool sold) async {
    try {
      var url = Uri.parse('${baseUrl}items/');
      var response =
          await http.get(url, headers: {'ended': '$ended', 'sold': '$sold'});
      if (response.statusCode == 200) {
        List<ItemsModel> _model = itemsModelFromJson(response.body);
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
    int sellerId,
    String token,
  ) async {
    try {
      var url = Uri.parse('${baseUrl}createItem/');
      Map<String, dynamic> data = {
        'name': name,
        'price': price,
        'postageCost': postageCost,
        'bidIncrement': bidIncrement,
        'condition': condition,
        'endDateTime': endDateTime.toIso8601String(),
        'acceptsReturns': acceptsReturns,
        'description': description,
        'sellerId': sellerId,
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
      double bid, int itemId, int accountId, String token) async {
    try {
      var url = Uri.parse('${baseUrl}items/$itemId/bid');
      Map<String, dynamic> data = {
        'accountId': accountId,
        'bid': bid,
      };
      var response = await http.post(url, body: json.encode(data), headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        int buyerId = body['buyerId'];
        double price = double.parse(body['price']);
        double minBid = price + double.parse(body['bidIncrement']);
        if (price == bid && buyerId == accountId) {
          return 'Bid of £$bid submitted.';
        } else if (bid < minBid) {
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
          List<ItemsModel> _model = itemsModelFromJson(response.body);
          return _model;
        } catch (e) {
          var jsonResponse = json.decode(response.body);
          ItemsModel _item = ItemsModel.fromJson(jsonResponse);
          List<ItemsModel> _model = [_item];
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
          List<ItemsModel> _model = itemsModelFromJson(response.body);
          return _model;
        } catch (e) {
          var jsonResponse = json.decode(response.body);
          ItemsModel _item = ItemsModel.fromJson(jsonResponse);
          List<ItemsModel> _model = [_item];
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
