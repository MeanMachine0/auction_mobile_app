import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_rest_api/models/user_model.dart';
import 'package:my_rest_api/models/accounts_model.dart';
import 'package:my_rest_api/models/items_model.dart';
import 'package:my_rest_api/models/endedItems_model.dart';
import 'package:my_rest_api/constants.dart';

class ApiService {
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

  Future<List<ItemsModel>?> getItems() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.itemsEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<ItemsModel> _model = ItemsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<EndedItemsModel>?> getEndedItems() async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.endedItemsEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<EndedItemsModel> _model = EndedItemsModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
