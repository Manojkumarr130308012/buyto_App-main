// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

CartResponse cartResponseFromJson(String str) =>
    CartResponse.fromJson(json.decode(str));

String cartResponseToJson(CartResponse data) => json.encode(data.toJson());

class CartResponse {
  String? grandTotal;
  List<Datum>? data;

  CartResponse({
    this.grandTotal,
    this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        grandTotal: json["grand_total"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "grand_total": grandTotal,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? name;
  int? ownerId;
  int? status;
  String? subTotal;
  int? shopId;
  num? new_sub_total;
  List<CartItem>? cartItems;

  Datum({
    this.name,
    this.ownerId,
    this.status,
    this.subTotal,
    this.shopId,
    this.new_sub_total,
    this.cartItems,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        ownerId: json["owner_id"],
        status: json["status"],
        subTotal: json["sub_total"],
        shopId: json["shop_id"],
        new_sub_total: json["new_sub_total"],
        cartItems: json["cart_items"] == null
            ? []
            : List<CartItem>.from(
                json["cart_items"]!.map((x) => CartItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "owner_id": ownerId,
        "status": status,
        "sub_total": subTotal,
        "cart_items": cartItems == null
            ? []
            : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
      };
}

class CartItem {
  int? id;
  int? ownerId;
  int? status;
  int? userId;
  int? productId;
  String? productName;
  int? auctionProduct;
  String? productThumbnailImage;
  String? variation;
  String? price;
  String? currencySymbol;
  String? tax;
  int? shippingCost;
  int? minimumOrderValue;
  int? quantity;
  int? lowerLimit;
  int? upperLimit;
  int? mrp;
  num? margin;
  double? buyToPrice;
  String? brand_name;
  String? category_name;

  CartItem(
      {this.id,
      this.ownerId,
      this.status,
      this.userId,
      this.productId,
      this.productName,
      this.auctionProduct,
      this.productThumbnailImage,
      this.variation,
      this.price,
      this.currencySymbol,
      this.tax,
      this.shippingCost,
      this.minimumOrderValue,
      this.quantity,
      this.lowerLimit,
      this.upperLimit,
      this.mrp,
      this.margin,
      this.buyToPrice,
      this.brand_name,
      this.category_name});

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        ownerId: json["owner_id"],
        status: json["status"],
        userId: json["user_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        auctionProduct: json["auction_product"],
        productThumbnailImage: json["product_thumbnail_image"],
        variation: json["variation"],
        price: json["price"],
        currencySymbol: json["currency_symbol"],
        tax: json["tax"],
        shippingCost: json["shipping_cost"],
        minimumOrderValue: json['minimum_order_value'],
        quantity: json["quantity"],
        lowerLimit: json["lower_limit"],
        upperLimit: json["upper_limit"],
        margin: json["margin"],
        buyToPrice: (json["buyto_price"] != null)
            ? json["buyto_price"].toDouble()
            : null,
        mrp: json["mrp"],
        brand_name: json["brand_name"],
        category_name: json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_id": ownerId,
        "status": status,
        "user_id": userId,
        "product_id": productId,
        "product_name": productName,
        "auction_product": auctionProduct,
        "product_thumbnail_image": productThumbnailImage,
        "variation": variation,
        "price": price,
        "currency_symbol": currencySymbol,
        "tax": tax,
        "shipping_cost": shippingCost,
        "minimum_order_value": minimumOrderValue,
        "quantity": quantity,
        "lower_limit": lowerLimit,
        "upper_limit": upperLimit,
        "margin": margin,
        "buyto_price": buyToPrice,
        "mrp": mrp,
        "category_name": category_name,
        "brand_name": brand_name,
      };
}
