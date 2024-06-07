import 'dart:convert';

QuantityResponse QuantityResponseFromJson(String str) =>
    QuantityResponse.fromJson(json.decode(str));

String wishListCheckResponseToJson(QuantityResponse data) =>
    json.encode(data.toJson());

// class QuantityResponse {
//   QuantityResponse({
//     this.success,
//     this.status,
//     this.size,
//     this.qty,
//   });
//
//   bool? success;
//   int? status;
//   List<String>? size;
//   List<int>? qty;
//
//   factory QuantityResponse.fromJson(Map<String, dynamic> json) =>
//       QuantityResponse(
//         success: json["success"],
//         status: json["status"],
//         size: List<String>.from(json["size"].map((x) => x)),
//         qty: List<int>.from(json["qty"].map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "status": status,
//     "size": List<dynamic>.from(size!.map((x) => x)),
//     "qty": List<dynamic>.from(qty!.map((x) => x)),
//   };
// }
class QuantityResponse {
  bool success;
  int status;
  List<Datum> data;

  QuantityResponse({
    required this.success,
    required this.status,
    required this.data,
  });

  factory QuantityResponse.fromJson(Map<String, dynamic> json) {
    return QuantityResponse(
      success: json['success'],
      status: json['status'],
      data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Datum {
  String size;
  int select_qty;
  int id;
  List<int> qty;

  Datum({
    required this.size,
    required this.select_qty,
    required this.id,
    required this.qty,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      size: json['size'],
      select_qty: json['select_qty'],
      id: json['id'] ?? 0,
      qty: List<int>.from(json['qty'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'select_qty': select_qty,
      'id': id,
      'qty': qty,
    };
  }
}
