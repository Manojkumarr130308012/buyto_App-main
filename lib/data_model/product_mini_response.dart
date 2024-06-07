// To parse this JSON data, do
//
//     final productMiniResponse = productMiniResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

ProductMiniResponse productMiniResponseFromJson(String str) =>
    ProductMiniResponse.fromJson(json.decode(str));

String productMiniResponseToJson(ProductMiniResponse data) =>
    json.encode(data.toJson());

class ProductMiniResponse {
  ProductMiniResponse({
    this.products,
    this.meta,
    this.success,
    this.status,
  });

  List<Product>? products;
  bool? success;
  int? status;
  Meta? meta;

  factory ProductMiniResponse.fromJson(Map<String, dynamic> json) =>
      ProductMiniResponse(
        products:
            List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(products!.map((x) => x.toJson())),
        "meta": meta == null ? null : meta!.toJson(),
        "success": success,
        "status": status,
      };
}

class Product {
  Product({
    this.id,
    this.seller_id,
    this.name,
    this.new_brand_name,
    this.new_category_name,
    this.thumbnail_image,
    this.main_price,
    this.stroked_price,
    this.has_discount,
    this.discount,
    this.rating,
    this.sales,
    this.links,
    this.isWholesale,
    this.margin,
    this.mrp,
    this.moq,
    this.unit_name,
    this.gender,
    this.color_code,
  });

  int? id;
  int? seller_id;
  String? name;
  String? new_brand_name;
  String? new_category_name;
  String? thumbnail_image;
  String? main_price;
  String? stroked_price;
  bool? has_discount;
  var discount;
  int? rating;
  int? sales;
  Links? links;
  bool? isWholesale;
  String? margin;
  int? mrp;
  int? moq;
  String? unit_name;
  String? gender;
  String? color_code;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      seller_id: json["seller_id"],
      name: json["name"],
      new_brand_name: json["new_brand_name"],
      new_category_name: json["new_category_name"],
      thumbnail_image: json["thumbnail_image"],
      main_price: json["main_price"],
      // margin: json["margin"].toString(),
      margin: json["retail_margin"].toString(),
      mrp: json["mrp"],
      moq: json["min_order_qty"],
      unit_name: json["unit_name"],
      stroked_price: json["stroked_price"],
      has_discount: json["has_discount"],
      discount: json["discount"],
      rating: json["rating"].toInt(),
      sales: json["sales"],
      links: Links.fromJson(json["links"]),
      isWholesale: json["is_wholesale"],
      gender: json["gender"],
      color_code: json["color_code"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": seller_id,
        "name": name,
        "brand_name": new_brand_name,
        "category_name": new_category_name,
        "thumbnail_image": thumbnail_image,
        "main_price": main_price,
        "stroked_price": stroked_price,
        "has_discount": has_discount,
        "discount": discount,
        "rating": rating,
        "sales": sales,
        "links": links!.toJson(),
        "is_wholesale": isWholesale,
        "margin": margin,
        "mrp": mrp,
        "moq": moq,
        "unit_name": unit_name,
        "gender": gender,
        "color_code": color_code
      };
}

class Links {
  Links({
    this.details,
  });

  String? details;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "details": details,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
