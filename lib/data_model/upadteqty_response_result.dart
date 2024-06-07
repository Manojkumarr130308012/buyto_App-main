import 'dart:convert';

CartUpdateResult cartUpdateResponseFromJson(String str) =>
    CartUpdateResult.fromJson(json.decode(str));

String cartUpdateResponseToJson(CartUpdateResult data) =>
    json.encode(data.toJson());

class CartUpdateResult {
  CartUpdateResult({
    this.result,
    this.message,
  });

  bool? result;
  String? message;

  factory CartUpdateResult.fromJson(Map<String, dynamic> json) =>
      CartUpdateResult(
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
