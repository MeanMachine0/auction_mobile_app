import 'dart:convert';

List<AccountsModel> accountsModelFromJson(String str) =>
    List<AccountsModel>.from(
        json.decode(str).map((x) => AccountsModel.fromJson(x)));

String accountsModelToJson(List<AccountsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountsModel {
  AccountsModel({
    required this.id,
    required this.user,
    required this.address,
    required this.balance,
  });

  int id;
  String user;
  String address;
  String balance;

  factory AccountsModel.fromJson(Map<String, dynamic> json) => AccountsModel(
        id: json["id"],
        user: json["user"],
        address: json["address"],
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "address": address,
        "balance": balance,
      };
}
