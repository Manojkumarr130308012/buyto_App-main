// To parse this JSON data, do
//
//     final addressUpdateLocationResponse = addressUpdateLocationResponseFromJson(jsonString);

import 'dart:convert';

AddressUpdateLocationResponse addressUpdateLocationResponseFromJson(String str) => AddressUpdateLocationResponse.fromJson(json.decode(str));

String addressUpdateLocationResponseToJson(AddressUpdateLocationResponse data) => json.encode(data.toJson());

class AddressUpdateLocationResponse {
  AddressUpdateLocationResponse({
    this.result,
    this.message,
  });

  bool? result;
  String? message;

  factory AddressUpdateLocationResponse.fromJson(Map<String, dynamic> json) => AddressUpdateLocationResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}



class ColorModel {
  bool status;
  String colorName;
  String thumbnailImage;

  ColorModel({
    required this.status,
    required this.colorName,
    required this.thumbnailImage,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      status: json['status'],
      colorName: json['color_name'],
      thumbnailImage: json['thumbnail_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['color_name'] = this.colorName;
    data['thumbnail_image'] = this.thumbnailImage;
    return data;
  }
}
