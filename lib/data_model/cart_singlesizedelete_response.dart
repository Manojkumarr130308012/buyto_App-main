// To parse this JSON data, do
//
//     final cartDeleteResponse = cartDeleteResponseFromJson(jsonString);

import 'dart:convert';

CartSingleSizeDeleteResponse cartSingleSizeDeleteResponseFromJson(String str) =>
    CartSingleSizeDeleteResponse.fromJson(json.decode(str));

String cartSingleSizeDeleteResponseToJson(CartSingleSizeDeleteResponse data) =>
    json.encode(data.toJson());

class CartSingleSizeDeleteResponse {
  CartSingleSizeDeleteResponse({
    this.result,
    this.message,
  });

  bool? result;
  String? message;

  factory CartSingleSizeDeleteResponse.fromJson(Map<String, dynamic> json) =>
      CartSingleSizeDeleteResponse(
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
