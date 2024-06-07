// To parse this JSON data, do
//
//     final wishlistResponse = wishlistResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

WishlistResponse wishlistResponseFromJson(String str) =>
    WishlistResponse.fromJson(json.decode(str));

String wishlistResponseToJson(WishlistResponse data) =>
    json.encode(data.toJson());

class WishlistResponse {
  WishlistResponse({
    this.wishlist_items,
    this.success,
    this.status,
  });

  List<WishlistItem>? wishlist_items;
  bool? success;
  int? status;

  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      WishlistResponse(
        wishlist_items: List<WishlistItem>.from(
            json["data"].map((x) => WishlistItem.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(wishlist_items!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class WishlistItem {
  WishlistItem({
    this.id,
    this.product,
  });

  int? id;
  Product? product;

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json["id"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product!.toJson(),
      };
}

class Product {
  Product({
    this.id,
    this.name,
    this.thumbnail_image,
    this.base_price,
    this.rating,
    this.new_category_name,
    this.new_brand_name,
    this.margin,
    this.mrp,
    this.moq,
    this.unit_name,
    this.gender,
    this.min_order_qty,
  });

  int? id;
  String? name;
  String? thumbnail_image;
  String? base_price;
  int? rating;
  String? new_category_name;
  String? new_brand_name;
  int? mrp;
  int? moq;
  String? unit_name;
  String? gender;
  int? margin;
  int? min_order_qty;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        thumbnail_image: json["thumbnail_image"],
        base_price: json["base_price"],
        rating: json["rating"],
        new_category_name: json["new_category_name"],
        new_brand_name: json["new_brand_name"],
        margin: json["margin"],
        mrp: json["mrp"],
        moq: json["moq"],
        unit_name: json["unit_name"],
        gender: json["gender"],
        min_order_qty: json["min_order_qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail_image": thumbnail_image,
        "base_price": base_price,
        "rating": rating,
        "new_category_name": new_category_name,
        "new_brand_name": new_brand_name,
        "margin": margin,
        "mrp": mrp,
        "moq": moq,
        "unit_name": unit_name,
        "gender": gender,
        "min_order_qty": min_order_qty,
      };
}
