import 'dart:convert';

List<AccountModel> accountsModelFromJson(String str) => List<AccountModel>.from(
    json.decode(str).map((x) => AccountModel.fromJson(x)));

String accountsModelToJson(List<AccountModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountModel {
  AccountModel({
    required this.id,
    required this.user,
    required this.address,
    required this.balance,
  });

  int id;
  String user;
  String address;
  String balance;

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
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
