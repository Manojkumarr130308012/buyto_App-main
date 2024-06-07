import 'dart:convert';

SellerMarketResponse sellerMarketResponseFromJson(String str) => SellerMarketResponse.fromJson(json.decode(str));

String sellerMarketResponseToJson(SellerMarketResponse data) => json.encode(data.toJson());

class SellerMarketResponse {
  SellerMarketResponse({
    this.market_name,
    this.success,
    this.status,
  });

  List<SellerMarket>? market_name;
  bool? success;
  int? status;

  factory SellerMarketResponse.fromJson(Map<String, dynamic> json) =>
      SellerMarketResponse(
        market_name: List<SellerMarket>.from(
            json["data"].map((x) => SellerMarket.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {
        "data": List<dynamic>.from(market_name!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };

}

class SellerMarket {
  SellerMarket({
    this.id,
    this.market_name,
    this.logo,
    this.links,
  });

  int? id;
  String? market_name;
  String? logo;
  Links? links;

  factory SellerMarket.fromJson(Map<String, dynamic> json) => SellerMarket(
    id: json["id"],
    market_name: json["market_name"],
    logo: json["logo"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "market_name": market_name,
    "logo": logo,
    "links": links!.toJson(),
  };
}

class Links {
  Links({
    this.products,
  });

  String? products;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    products: json["products"],
  );

  Map<String, dynamic> toJson() => {
    "products": products,
  };
}