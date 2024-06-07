// To parse this JSON data, do
//
//     final brandResponse = brandResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

SoleCategoryResponse soleCategoryResponseFromJson(String str) => SoleCategoryResponse.fromJson(json.decode(str));

String soleCategoryResponseToJson(SoleCategoryResponse data) => json.encode(data.toJson());

class SoleCategoryResponse {
  SoleCategoryResponse({
    this.solecategory,
    this.meta,
    this.success,
    this.status,
  });

  List<Solecategory>? solecategory;
  Meta? meta;
  bool? success;
  int? status;

  factory SoleCategoryResponse.fromJson(Map<String, dynamic> json) => SoleCategoryResponse(
    solecategory: List<Solecategory>.from(json["data"].map((x) => Solecategory.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(solecategory!.map((x) => x.toJson())),
    "meta": meta == null ? null : meta!.toJson(),
    "success": success,
    "status": status,
  };
}

class Solecategory {
  Solecategory({
    this.id,
    this.name,
    this.logo,
    this.links,
  });

  int? id;
  String? name;
  String? logo;
  BrandsLinks? links;

  factory Solecategory.fromJson(Map<String, dynamic> json) => Solecategory(
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
