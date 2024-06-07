import 'dart:convert';

EditCartOrder orderFromJson(String str) =>
    EditCartOrder.fromJson(json.decode(str));

String editOrderResponseToJson(EditCartOrder data) =>
    json.encode(data.toJson());

class EditCartOrder {
  EditCartOrder({
    required this.grandTotal,
    required this.data,
  });

  String grandTotal;
  List<Datum> data;

  factory EditCartOrder.fromJson(Map<String, dynamic> json) => EditCartOrder(
    grandTotal: json["grand_total"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "grand_total": grandTotal,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.name,
    required this.ownerId,
    required this.subTotal,
    required this.cartItems,
  });

  String name;
  int ownerId;
  String subTotal;
  List<EditCartItem> cartItems;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    ownerId: json["owner_id"],
    subTotal: json["sub_total"],
    cartItems: json["cart_items"] == null
        ? []
        : List<EditCartItem>.from(
        json["cart_items"]!.map((x) => EditCartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner_id": ownerId,
    "sub_total": subTotal,
    "cart_items": cartItems == null
        ? []
        : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
  };
}

class EditCartItem {
  EditCartItem({
    required this.id,
    required this.ownerId,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.auctionProduct,
    required this.productThumbnailImage,
    required this.brandName,
    required this.categoryName,
    required this.unitName,
    required this.mrp,
    required this.colorName,
    required this.colorCode,
    required this.sellerName,
    required this.sellerImage,
    required this.minimumOrderValue,
    required this.margin,
    required this.buytoPrice,
    required this.variation,
    required this.price,
    required this.currencySymbol,
    required this.tax,
    required this.shippingCost,
    required this.quantity,
    required this.lowerLimit,
    required this.upperLimit,
  });

  int id;
  int ownerId;
  int userId;
  int productId;
  String productName;
  int auctionProduct;
  String productThumbnailImage;
  String brandName;
  String categoryName;
  String unitName;
  int mrp;
  String colorName;
  String colorCode;
  String sellerName;
  String sellerImage;
  dynamic minimumOrderValue;
  double margin;
  double buytoPrice;
  String variation;
  String price;
  String currencySymbol;
  String tax;
  int shippingCost;
  int quantity;
  int lowerLimit;
  int upperLimit;

  factory EditCartItem.fromJson(Map<String, dynamic> json) => EditCartItem(
    id: json["id"],
    ownerId: json["owner_id"],
    userId: json["user_id"],
    productId: json["product_id"],
    productName: json["product_name"],
    auctionProduct: json["auction_product"],
    productThumbnailImage: json["product_thumbnail_image"],
    brandName: json["brand_name"],
    categoryName: json["category_name"],
    unitName: json["unit_name"],
    mrp: json["mrp"],
    colorName: json["color_name"],
    colorCode: json["color_code"],
    sellerName: json["seller_name"],
    sellerImage: json["seller_image"],
    minimumOrderValue: json["minimum_order_value"],
    margin: json["margin"].toDouble(),
    buytoPrice: json["buyto_price"].toDouble(),
    variation: json["variation"],
    price: json["price"],
    currencySymbol: json["currency_symbol"],
    tax: json["tax"],
    shippingCost: json["shipping_cost"],
    quantity: json["quantity"],
    lowerLimit: json["lower_limit"],
    upperLimit: json["upper_limit"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "user_id": userId,
    "product_id": productId,
    "product_name": productName,
    "auction_product": auctionProduct,
    "product_thumbnail_image": productThumbnailImage,
    "brand_name": brandName,
    "category_name": categoryName,
    "unit_name": unitName,
    "mrp": mrp,
    "color_name": colorName,
    "color_code": colorCode,
    "seller_name": sellerName,
    "seller_image": sellerImage,
    "minimum_order_value": minimumOrderValue,
    "margin": margin,
    "buyto_price": buytoPrice,
    "variation": variation,
    "price": price,
    "currency_symbol": currencySymbol,
    "tax": tax,
    "shipping_cost": shippingCost,
    "quantity": quantity,
    "lower_limit": lowerLimit,
    "upper_limit": upperLimit,
  };
}
