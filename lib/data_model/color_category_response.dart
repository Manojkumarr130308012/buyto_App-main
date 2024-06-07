// To parse this JSON data, do
//
//     final brandResponse = brandResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

ColorCategoryResponse colorCategoryResponseFromJson(String str) => ColorCategoryResponse.fromJson(json.decode(str));

String colorCategoryResponseToJson(ColorCategoryResponse data) => json.encode(data.toJson());

class ColorCategoryResponse {
  ColorCategoryResponse({
    this.colorcategory,
    this.meta,
    this.success,
    this.status,
  });

  List<Colorcategory>? colorcategory;
  Meta? meta;
  bool? success;
  int? status;

  factory ColorCategoryResponse.fromJson(Map<String, dynamic> json) => ColorCategoryResponse(
    colorcategory: List<Colorcategory>.from(json["data"].map((x) => Colorcategory.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(colorcategory!.map((x) => x.toJson())),
    "meta": meta == null ? null : meta!.toJson(),
    "success": success,
    "status": status,
  };
}

class Colorcategory {
  Colorcategory({
    this.id,
    this.name,
    // this.logo,
    // this.links,
  });

  String? id;
  String? name;
  // String? logo;
  // BrandsLinks? links;

  factory Colorcategory.fromJson(Map<String, dynamic> json) => Colorcategory(
    name: json["name"],
    id: json["code"],
    // logo: json["logo"],
    // links: BrandsLinks.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    // "logo": logo,
    // "links": links!.toJson(),
  };
}

class BrandsLinks {
  BrandsLinks({
    this.products,
  });

  String? products;

  factory BrandsLinks.fromJson(Map<String, dynamic> json) => BrandsLinks(
    products: json["products"],
  );

  Map<String, dynamic> toJson() => {
    "products": products,
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
