// To parse this JSON data, do
//
//     final brandResponse = brandResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

SizeCategoryResponse sizeCategoryResponseFromJson(String str) => SizeCategoryResponse.fromJson(json.decode(str));

String sizeCategoryResponseToJson(SizeCategoryResponse data) => json.encode(data.toJson());

class SizeCategoryResponse {
  SizeCategoryResponse({
    this.sizecategory,
    this.meta,
    this.success,
    this.status,
  });

  List<Sizecategory>? sizecategory;
  Meta? meta;
  bool? success;
  int? status;

  factory SizeCategoryResponse.fromJson(Map<String, dynamic> json) => SizeCategoryResponse(
    sizecategory: List<Sizecategory>.from(json["data"].map((x) => Sizecategory.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(sizecategory!.map((x) => x.toJson())),
    "meta": meta == null ? null : meta!.toJson(),
    "success": success,
    "status": status,
  };
}

class Sizecategory {
  Sizecategory({
    this.id,
    this.name,
    this.logo,
    this.links,
  });

  int? id;
  String? name;
  String? logo;
  BrandsLinks? links;

  factory Sizecategory.fromJson(Map<String, dynamic> json) => Sizecategory(
    name: json["name"],
    id: json["id"],
    logo: json["logo"],
    links: BrandsLinks.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "logo": logo,
    "links": links!.toJson(),
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
