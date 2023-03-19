import 'dart:convert';

List<ItemsModel> ItemsModelFromJson(String str) =>
    List<ItemsModel>.from(json.decode(str).map((x) => ItemsModel.fromJson(x)));

String ItemsModelToJson(List<ItemsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsModel {
  ItemsModel({
    required this.id,
    required this.name,
    required this.price,
    required this.postageCost,
    required this.bidIncrement,
    required this.condition,
    required this.endDateTime,
    required this.acceptReturns,
    required this.description,
    required this.numBids,
    required this.bidders,
    required this.sold,
    this.buyerId,
    required this.sellerId,
  });

  int id;
  String name;
  String price;
  String postageCost;
  String bidIncrement;
  String condition;
  DateTime endDateTime;
  bool acceptReturns;
  String description;
  int numBids;
  String bidders;
  bool sold;
  dynamic buyerId;
  int sellerId;

  factory ItemsModel.fromJson(Map<String, dynamic> json) => ItemsModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        postageCost: json["postageCost"],
        bidIncrement: json["bidIncrement"],
        condition: json["condition"],
        endDateTime: DateTime.parse(json["endDateTime"]),
        acceptReturns: json["acceptReturns"],
        description: json["description"],
        numBids: json["numBids"],
        bidders: json["bidders"],
        sold: json["sold"],
        buyerId: json["buyerId"],
        sellerId: json["sellerId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "postageCost": postageCost,
        "bidIncrement": bidIncrement,
        "condition": condition,
        "endDateTime": endDateTime.toIso8601String(),
        "acceptReturns": acceptReturns,
        "description": description,
        "numBids": numBids,
        "bidders": bidders,
        "sold": sold,
        "buyerId": buyerId,
        "sellerId": sellerId,
      };
}
