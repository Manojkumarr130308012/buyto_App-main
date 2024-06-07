import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/cart_add_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_count_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_process_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_response.dart';
import 'package:active_ecommerce_flutter/data_model/cart_summary_response.dart';
import 'package:active_ecommerce_flutter/data_model/check_response_model.dart';
import 'package:active_ecommerce_flutter/helpers/response_check.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/middlewares/banned_user.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:localstorage/localstorage.dart';

import '../data_model/cart_singlesizedelete_response.dart';
import '../data_model/edit_order_response.dart';

class CartRepository {
  Future<dynamic> getCartResponseList(
    int? user_id,
  ) async {
    String url = ("${AppConfig.BASE_URL}/carts");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: '',
        middleware: BannedUser());
    // print(response.body);
    return cartResponseFromJson(response.body);
  }

  Future<dynamic> getCartCount() async {
    if (is_logged_in.$) {
      String url = ("${AppConfig.BASE_URL}/cart-count");
      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
      );
      bool checkResult = ResponseCheck.apply(response.body);

      if (!checkResult) return responseCheckModelFromJson(response.body);

      return cartCountResponseFromJson(response.body);
    } else {
      return CartCountResponse(count: 0, status: false);
    }
  }

  Future<dynamic> getCartDeleteResponse(
    int? cart_id,
  ) async {
    String url = ("${AppConfig.BASE_URL}/carts/$cart_id");
    final response = await ApiRequest.delete(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser());
    return cartDeleteResponseFromJson(response.body);
  }

  //seller delete api
  Future<dynamic> getSellerDeleteResponse(int user_id, int? owner_id) async {
    var post_body = jsonEncode({"user_id": user_id, "owner_id": owner_id});
    String url = ("${AppConfig.BASE_URL}/carts/remove");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser(),
        body: post_body);
    return cartDeleteResponseFromJson(response.body);
  }

  Future<dynamic> getCartProcessResponse(
      String cart_ids, String cart_quantities) async {
    var post_body = jsonEncode(
        {"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});

    String url = ("${AppConfig.BASE_URL}/carts/process");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return cartProcessResponseFromJson(response.body);
  }

  Future<dynamic> getCartAddResponse(
      int? id, String? variant, int? user_id, int? quantity) async {
    var post_body = jsonEncode({
      // "id": "${id}",
      // "variant": variant,
      // "user_id": "$user_id",
      // "quantity": "$quantity",
      // "cost_matrix": AppConfig.purchase_code

      // "id":33,
      // "variant":"100Gm",
      // "user_id":16,
      // "is_buynow":"0",
      // "quantity":4,
      // "buyertype":1
      "id": "${id}",
      "variant": "100Gm",
      "user_id": "$user_id",
      "quantity": "$quantity",
      // "quantity": 26,
      "buyertype": 1
    });

    String url = ("${AppConfig.BASE_URL}/carts/add");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());

    return cartAddResponseFromJson(response.body);
  }

  Future<dynamic> getCartAddNewResponse(
      int? id, List<int?>? variant, List<int?>? quantity) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "variant": variant,
      "quantity": quantity,
    });
    print(post_body);
    String url = ("${AppConfig.BASE_URL}/carts/add-new");
    print(url);

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    print(response);

    return cartAddResponseFromJson(response.body);
  }

  Future<dynamic> getCartSummaryResponse() async {
    String url = ("${AppConfig.BASE_URL}/cart-summary");
    // print(" cart summary");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    // print(response.body);
    return cartSummaryResponseFromJson(response.body);
  }

  // edit order cart page

  Future<dynamic> getEditOrderCartPage(int? user_ids, int owner_id) async {
    var post_body = jsonEncode({"user_id": user_ids, "owner_id": owner_id});
    String url = ("${AppConfig.BASE_URL}/carts/products");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser(),
        body: post_body);

    // print('list responses ----------------------------${response.body}');
    return orderFromJson(response.body);
  }

  //edit product page

  Future<dynamic> getEditOrderProductPage(int? owner_id, int product_id) async {
    var post_body =
        jsonEncode({"owner_id": owner_id, "product_id": product_id});
    String url = ("${AppConfig.BASE_URL}/carts/edit/products");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser(),
        body: post_body);

    // print('edit responses ----------------------------${response.body}');
    return orderFromJson(response.body);
  }

  //seller product
  Future<dynamic> getEditOrderSellerDeleteResponse(
      int? user_id, int? owner_id, int? product_id) async {
    var post_body = jsonEncode(
        {"user_id": user_id, "owner_id": owner_id, "product_id": product_id});
    String url = ("${AppConfig.BASE_URL}/carts/remove/product");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser(),
        body: post_body);
    // print('delete responses ----------------------------${response.body}');
    return cartDeleteResponseFromJson(response.body);
  }

  //quantity update

  Future<dynamic> getQuantityUpdateResponse(
      int? id, List<int?> variant, List<int?> quantity) async {
    var post_body = jsonEncode(
        {"product_id": id, "variant": variant, "quantity": quantity});
    // print(post_body);
    String url = ("${AppConfig.BASE_URL}/carts/update-quantity");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser(),
        body: post_body);
    // print('update responses ----------------------------${response.body}');
    return cartDeleteResponseFromJson(response.body);
  }

  //quantity check api

  Future<dynamic> getQuantityCheckResponse(
      int? product_id, int? quantity) async {
    var post_body =
        jsonEncode({"product_id": product_id, "quantity": quantity});
    print('update responses ----------------------------${post_body}');
    String url = ("${AppConfig.BASE_URL}/carts/check-qty");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser(),
        body: post_body);
    // print('update responses ----------------------------${response.body}');
    return cartDeleteResponseFromJson(response.body);
  }

  //seller status update

  Future<dynamic> getSellerStausResponse(int? owner_id, int? status) async {
    var post_body = jsonEncode({"owner_id": owner_id, "status": status});
    String url = ("${AppConfig.BASE_URL}/carts/update-cart-status");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser(),
        body: post_body);
    // print('update responses ----------------------------${response.body}');
    return cartDeleteResponseFromJson(response.body);
  }

  Future<dynamic> getCartSingleSizeDeleteResponse(
      int? ownerid, int? productid, String? variation) async {
    var post_body = jsonEncode(
        {"owner_id": ownerid, "product_id": productid, "size": variation});
    String url = ("${AppConfig.BASE_URL}/carts/remove/single-product");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser(),
        body: post_body);
    return cartSingleSizeDeleteResponseFromJson(response.body);
  }
}
