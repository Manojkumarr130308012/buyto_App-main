// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

ShoesCollectionResponse shoesCollectionResponseFromJson(String str) => ShoesCollectionResponse.fromJson(json.decode(str));

String shoesCollectionResponseToJson(ShoesCollectionResponse data) => json.encode(data.toJson());

class ShoesCollectionResponse {
  ShoesCollectionResponse({
    this.name,
    this.success,
    this.status,
  });

  List<ShoesCollection>? name;
  bool? success;
  int? status;

  factory ShoesCollectionResponse.fromJson(Map<String, dynamic> json) => ShoesCollectionResponse(
    name: List<ShoesCollection>.from(json["data"].map((x) => ShoesCollection.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(name!.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class ShoesCollection {
  ShoesCollection({
    this.id,
    this.name,
    this.banner,
    this.icon,
    this.number_of_children,
    this.links,
  });

  int? id;
  String? name;
  String? banner;
  String? icon;
  int? number_of_children;
  Links? links;

  factory ShoesCollection.fromJson(Map<String, dynamic> json) => ShoesCollection(
    id: json["id"],
    name: json["name"],
    banner: json["banner"],
    icon: json["icon"],
    number_of_children: json["number_of_children"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "banner": banner,
    "icon": icon,
    "number_of_children": number_of_children,
    "links": links!.toJson(),
  };
}

class Links {
  Links({
    this.products,
    this.subCategories,
  });

  String? products;
  String? subCategories;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    products: json["products"],
    subCategories: json["sub_categories"],
  );

  Map<String, dynamic> toJson() => {
    "products": products,
    "sub_categories": subCategories,
  };
}

class Sole {
  Sole({
    this.name,
    this.logo,
    this.id,
  });

  String? name;
  String? logo;
  int? id;

  factory Sole.fromJson(Map<String, dynamic> json) => Sole(
    name: json["name"],
    logo: json["logo"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "logo": logo,
    "id": id,
  };
}