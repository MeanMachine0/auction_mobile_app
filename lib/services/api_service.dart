import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:auction_mobile_app/models/user_model.dart';
import 'package:auction_mobile_app/models/accounts_model.dart';
import 'package:auction_mobile_app/models/items_model.dart';
import 'package:auction_mobile_app/models/ended_items_model.dart';
import 'package:auction_mobile_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<List<String>?> login(String username, String password) async {
    try {
      Map<String, dynamic> data = {'username': username, 'password': password};
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
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
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.logoutEndpoint);
      await http.post(url, headers: {'Authorization': 'Token $token'});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<UserModel>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<UserModel> _model = userModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<AccountsModel?> getAccount(int accountId) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.accountsEndpoint}$accountId/');
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

  Future<List<AccountsModel>?> getAccounts() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.accountsEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<AccountsModel> _model = accountsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<ItemsModel?> getItem(int itemId) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}$itemId/');
      var response = await http.get(url);

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

  Future<List<ItemsModel>?> getItems() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.itemsEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<ItemsModel> _model = itemsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<EndedItemsModel?> getEndedItem(int itemId) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.endedItemsEndpoint}$itemId/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        EndedItemsModel item = EndedItemsModel.fromJson(jsonResponse);
        return item;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<List<EndedItemsModel>?> getEndedItems(bool sold) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.endedItemsEndpoint);
      var response = await http.get(url, headers: {'sold': '$sold'});
      if (response.statusCode == 200) {
        List<EndedItemsModel> _model = endedItemsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void createItem(
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
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.createItemEndpoint);
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
      await http.post(url, body: json.encode(data), headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> submitBid(
      double bid, int itemId, int accountId, String token) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.itemsEndpoint}$itemId/${ApiConstants.bidEndpoint}');
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

  Future<List<ItemsModel>?> getAccountItems(int accountId) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.accountsEndpoint}$accountId/${ApiConstants.itemsEndpoint}');
      var response = await http.get(
        url,
        headers: {'ended': 'false'},
      );
      if (response.statusCode == 200) {
        try {
          var jsonResponse = json.decode(response.body);
          ItemsModel _item = ItemsModel.fromJson(jsonResponse);
          List<ItemsModel> _model = [_item];
          return _model;
        } catch (e) {
          List<ItemsModel> _model = itemsModelFromJson(response.body);
          return _model;
        }
      } else if (response.statusCode == 404) {
        List<ItemsModel> _model = [
          ItemsModel(
            id: 404,
            name: "404 Not Found",
            price: "404.00",
            postageCost: "404.00",
            bidIncrement: "404.00",
            condition: "404",
            endDateTime: DateTime(404),
            acceptReturns: false,
            description: "404 - Item not found",
            numBids: 404,
            bidders: "404",
            sold: false,
            buyerId: 404,
            sellerId: 404,
          )
        ];
        return _model;
      }
      return [];
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<EndedItemsModel>?> getAccountEndedItems(int accountId) async {
    try {
      var url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.accountsEndpoint}$accountId/${ApiConstants.itemsEndpoint}');
      var response = await http.get(
        url,
        headers: {'ended': 'true'},
      );
      if (response.statusCode == 200) {
        try {
          var jsonResponse = json.decode(response.body);
          EndedItemsModel _item = EndedItemsModel.fromJson(jsonResponse);
          List<EndedItemsModel> _model = [_item];
          return _model;
        } catch (e) {
          List<EndedItemsModel> _model = endedItemsModelFromJson(response.body);
          return _model;
        }
      } else if (response.statusCode == 404) {
        List<EndedItemsModel> _model = [
          EndedItemsModel(
            id: 404,
            name: "404 Not Found",
            salePrice: "404.00",
            postageCost: "404.00",
            bidIncrement: "404.00",
            condition: "404",
            endDateTime: DateTime(404),
            acceptReturns: false,
            description: "404 - Item not found",
            numBids: 404,
            bidders: "404",
            sold: false,
            buyerId: 404,
            sellerId: 404,
            destinationAddress: '404 Street',
          )
        ];
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
