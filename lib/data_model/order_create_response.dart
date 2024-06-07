// To parse this JSON data, do
//
//     final orderCreateResponse = orderCreateResponseFromJson(jsonString);

import 'dart:convert';

OrderCreateResponse orderCreateResponseFromJson(String str) => OrderCreateResponse.fromJson(json.decode(str));

String orderCreateResponseToJson(OrderCreateResponse data) => json.encode(data.toJson());

class OrderCreateResponse {
  OrderCreateResponse({
    this.combined_order_id,
    this.result,
    this.message,
    this.seller_id,
    this.code,this.seller_name
  });

  int? combined_order_id;
  bool? result;
  String? message;
  int? seller_id;
  String? seller_name;
  String? code;

  factory OrderCreateResponse.fromJson(Map<String, dynamic> json) => OrderCreateResponse(
    combined_order_id: json["combined_order_id"],
    result: json["result"],
    message: json["message"],
      seller_id: json['seller_id'],
      seller_name: json['seller_name'],
      code: json['code']
  );

  Map<String, dynamic> toJson() => {
    "combined_order_id": combined_order_id,
    "result": result,
    "message": message,
    "seller_id":seller_id,
    "seller_name":seller_name,
    "code":code
  };
}