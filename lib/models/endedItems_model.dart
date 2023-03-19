import 'dart:convert';

List<EndedItemsModel> EndedItemsModelFromJson(String str) =>
    List<EndedItemsModel>.from(
        json.decode(str).map((x) => EndedItemsModel.fromJson(x)));

String EndedItemsModelToJson(List<EndedItemsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EndedItemsModel {
  EndedItemsModel({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.postageCost,
    required this.bidIncrement,
    required this.condition,
    required this.endDateTime,
    required this.acceptReturns,
    required this.description,
    required this.numBids,
    required this.bidders,
    required this.sold,
    required this.buyerId,
    required this.sellerId,
    required this.destinationAddress,
  });

  int id;
  String name;
  String salePrice;
  String postageCost;
  String bidIncrement;
  String condition;
  DateTime endDateTime;
  bool acceptReturns;
  String description;
  int numBids;
  String bidders;
  bool sold;
  int buyerId;
  int sellerId;
  String destinationAddress;

  factory EndedItemsModel.fromJson(Map<String, dynamic> json) =>
      EndedItemsModel(
        id: json["id"],
        name: json["name"],
        salePrice: json["salePrice"],
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
        destinationAddress: json["destinationAddress"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "salePrice": salePrice,
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
        "destinationAddress": destinationAddress,
      };
}
