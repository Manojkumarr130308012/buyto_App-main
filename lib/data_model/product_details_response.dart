// To parse this JSON data, do
//
//     final productDetailsResponse = productDetailsResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

ProductDetailsResponse productDetailsResponseFromJson(String str) =>
    ProductDetailsResponse.fromJson(json.decode(str));

String productDetailsResponseToJson(ProductDetailsResponse data) =>
    json.encode(data.toJson());

class ProductDetailsResponse {
  ProductDetailsResponse({
    this.detailed_products,
    this.success,
    this.status,
    this.detailed_Colorproducts,
  });

  List<DetailedProduct>? detailed_products;
  bool? success;
  int? status;

  List<DetailedProduct>? detailed_Colorproducts;

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ProductDetailsResponse(
        detailed_products: List<DetailedProduct>.from(
            json["data"].map((x) => DetailedProduct?.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(detailed_products!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class DetailedProduct {
  DetailedProduct(
      {this.id,
      this.name,
      this.added_by,
      this.seller_id,
      this.shop_id,
      this.shop_name,
      this.shop_logo,
      this.photos,
      this.thumbnail_image,
      this.tags,
      this.price_high_low,
      this.choice_options,
      this.colors,
      this.has_discount,
      this.discount,
      this.stroked_price,
      this.main_price,
      this.calculable_price,
      this.currency_symbol,
      this.current_stock,
      this.unit,
      this.rating,
      this.rating_count,
      this.earn_point,
      this.description,
      this.downloads,
      this.video_link,
      this.color_name,
      this.link,
      this.new_category_name,
      this.moq,
      this.minimum_order_value,
      // this.buyto_tax_value,
      this.buyto_rate,
      this.gender,
      this.brand,
      this.mrp,
      this.margin,
      this.wholesale,
      this.estShippingTime});

  int? id;
  String? name;
  String? added_by;
  int? seller_id;
  int? shop_id;
  String? shop_name;
  String? shop_logo;
  List<Photo>? photos;
  String? thumbnail_image;
  List<String>? tags;
  String? price_high_low;
  List<ChoiceOption>? choice_options;
  List<dynamic>? colors;
  bool? has_discount;
  var discount;
  String? stroked_price;
  String? main_price;
  var calculable_price;
  String? currency_symbol;
  int? current_stock;
  String? unit;
  String? gender;
  int? rating;
  int? rating_count;
  int? earn_point;
  String? description;
  String? downloads;
  String? video_link;
  String? color_name;
  int? minimum_order_value;
  num? buyto_rate;
  // int? buyto_tax_value;
  String? link;
  String? new_category_name;
  int? moq;
  Brand? brand;
  List<Wholesale>? wholesale;
  int? estShippingTime;
  int? mrp;
  num? margin;

  factory DetailedProduct.fromJson(Map<String, dynamic> json) =>
      DetailedProduct(
        id: json["id"],
        name: json["name"],
        new_category_name: json["new_category_name"],
        added_by: json["added_by"],
        seller_id: json["seller_id"],
        shop_id: json["shop_id"],
        shop_name: json["seller_name"],
        shop_logo: json["seller_image"],
        estShippingTime: json["est_shipping_time"],
        photos:
            List<Photo>.from(json["photos"]?.map((x) => Photo?.fromJson(x))),
        thumbnail_image: json["thumbnail_image"],
        // tags: List<String>.from(json["tags"].map((x) => x)),
        price_high_low: json["price_high_low"],
        choice_options: List<ChoiceOption>.from(
            json["choice_options"].map((x) => ChoiceOption.fromJson(x))),
        colors: List<String>.from(json["colors"].map((x) => x)),
        has_discount: json["has_discount"],
        discount: json["discount"],
        // stroked_price: json["stroked_price"],
        stroked_price: json["buyto_tax_value"].toString(),
        main_price: json["main_price"],
        // calculable_price: json["calculable_price"],
        calculable_price: json["calculable_price"],
        currency_symbol: json["currency_symbol"],
        current_stock: json["current_stock"],
        unit: json["unit_name"],
        color_name: json["color_name"],
        rating: json["rating"].toInt(),
        rating_count: json["rating_count"],
        earn_point: json["earn_point"].toInt(),
        description: json["description"] == null || json["description"] == ""
            ? "No Description is available"
            : json['description'],
        downloads: json["downloads"],
        video_link: json["video_link"],
        link: json["link"],
        moq: json["min_order_qty"],
        margin: json["retail_margin"],
        gender: json["gender"],
        mrp: json["mrp"],
        minimum_order_value: json["minimum_order_value"],
        buyto_rate: json["buyto_rate"],
        // buyto_tax_value: json["buyto_tax_value"],
        brand: Brand.fromJson(json["brand"]),
        wholesale: List<Wholesale>.from(
            json["wholesale"].map((x) => Wholesale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "new_category_name": new_category_name,
        "added_by": added_by,
        "seller_id": seller_id,
        "shop_id": shop_id,
        "est_shipping_time": estShippingTime,
        "shop_name": shop_name,
        "shop_logo": shop_logo,
        "photos": List<dynamic>.from(photos!.map((x) => x.toJson())),
        "thumbnail_image": thumbnail_image,
        "tags": List<dynamic>.from(tags!.map((x) => x)),
        "price_high_low": price_high_low,
        "choice_options":
            List<dynamic>.from(choice_options!.map((x) => x.toJson())),
        "colors": List<dynamic>.from(colors!.map((x) => x)),
        "discount": discount,
        "stroked_price": stroked_price,
        "main_price": main_price,
        "calculable_price": calculable_price,
        "currency_symbol": currency_symbol,
        "current_stock": current_stock,
        "unit": unit,
        "rating": rating,
        "rating_count": rating_count,
        "earn_point": earn_point,
        "description": description,
        "downloads": downloads,
        "video_link": video_link,
        "color_name": color_name,
        "buyto_rate": buyto_rate,
        // "buyto_tax_value": buyto_tax_value,
        "link": link,
        "moq": moq,
        "minimum_order_value": minimum_order_value,
        "margin": margin,
        "mrp": mrp,
        "brand": brand!.toJson(),
        "wholesale": List<dynamic>.from(wholesale!.map((x) => x.toJson())),
      };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.logo,
  });

  int? id;
  String? name;
  String? logo;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
      };
}

class Photo {
  Photo({
    this.variant,
    this.path,
  });

  String? variant;
  String? path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        variant: json["variant"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "variant": variant,
        "path": path,
      };
}

class ChoiceOption {
  ChoiceOption({
    this.name,
    this.title,
    this.options,
  });

  String? name;
  String? title;
  List<String>? options;

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        name: json["name"],
        title: json["title"],
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "options": List<dynamic>.from(options!.map((x) => x)),
      };
}

class Wholesale {
  var minQty;
  var maxQty;
  var price;

  Wholesale({
    this.minQty,
    this.maxQty,
    this.price,
  });

  factory Wholesale.fromJson(Map<String, dynamic> json) => Wholesale(
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "min_qty": minQty,
        "max_qty": maxQty,
        "price": price,
      };
}

class ColorProduct {
  ColorProduct({
    this.path,
    this.id,
  });

  String? path;
  int? id;

  factory ColorProduct.fromJson(Map<String, dynamic> json) => ColorProduct(
        path: json["thumbnail_image"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "id": id,
      };
}
