import 'dart:convert';

SandlesCollectionResponse sandlesCollectionResponseFromJson(String str) => SandlesCollectionResponse.fromJson(json.decode(str));

String sandlesCollectionResponseToJson(SandlesCollection data) => json.encode(data.toJson());

class SandlesCollectionResponse {
  SandlesCollectionResponse({
    this.name,
    this.success,
    this.status,
  });

  List<SandlesCollection>? name;
  bool? success;
  int? status;

  factory SandlesCollectionResponse.fromJson(Map<String, dynamic> json) =>
      SandlesCollectionResponse(
        name: List<SandlesCollection>.from(
            json["data"].map((x) => SandlesCollection.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() =>
      {
        "data": List<dynamic>.from(name!.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };

}

class SandlesCollection {
  SandlesCollection({
    this.id,
    this.name,
    this.logo,
    this.links,
  });

  int? id;
  String? name;
  String? logo;
  Links? links;

  factory SandlesCollection.fromJson(Map<String, dynamic> json) => SandlesCollection(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    links: Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
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