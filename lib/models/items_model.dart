import 'dart:convert';

List<ItemsModel> itemsModelFromJson(String str) =>
    List<ItemsModel>.from(json.decode(str).map((x) => ItemsModel.fromJson(x)));

String itemsModelToJson(List<ItemsModel> data) =>
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
    required this.ended,
    required this.sold,
    this.buyer,
    required this.seller,
    this.destinationAddress,
    this.transactionSuccess,
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
  bool ended;
  bool sold;
  int? buyer;
  int seller;
  String? destinationAddress;
  bool? transactionSuccess;

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
        ended: json["ended"],
        sold: json["sold"],
        buyer: json["buyer"],
        seller: json["seller"],
        destinationAddress: json["destinationAddress"],
        transactionSuccess: json["transactionSuccess"],
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
        "buyer": buyer,
        "seller": seller,
        "destinationAddress": destinationAddress,
        "transactionSuccess": transactionSuccess,
      };
}
