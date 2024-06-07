import 'dart:convert';

PriceCategoryResponse priceCategoryResponseFromJson(String str) => PriceCategoryResponse.fromJson(json.decode(str));

String priceCategoryResponseToJson(PriceCategoryResponse data) => json.encode(data.toJson());

class PriceCategoryResponse {
  PriceCategoryResponse({
    this.price_category,
    this.success,
    this.status,
  });

  List<PriceCategory>? price_category;
  bool? success;
  int? status;

  factory PriceCategoryResponse.fromJson(Map<String, dynamic> json) =>
      PriceCategoryResponse(
        price_category: List<PriceCategory>.from(
            json["data"].map((x) => PriceCategory.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {
        "data": List<dynamic>.from(price_category!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };

}

class PriceCategory {
  PriceCategory({
    this.id,
    this.price_category,
    this.logo,
    this.links,
  });

  int? id;
  String? price_category;
  String? logo;
  Links? links;

  factory PriceCategory.fromJson(Map<String, dynamic> json) => PriceCategory(
    id: json["id"],
    price_category: json["price_category"],
    logo: json["logo"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price_category": price_category,
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