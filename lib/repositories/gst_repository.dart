import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/cart_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/search_suggestion_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';

class GstRepository {
  Future<dynamic> getGstInvoiceResponse({ required String gst_number}) async {
    String url = ("${AppConfig.BASE_URL}/gst_number/store");
    var post_body = jsonEncode({
      "gst_number": "${gst_number}",
    });

    final response = await ApiRequest.post(
      url: url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
      body: post_body,
    );

    print(response.body);
    return cartDeleteResponseFromJson(response.body);
  }
}
