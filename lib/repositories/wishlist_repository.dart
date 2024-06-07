import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_check_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_delete_response.dart';
import 'package:active_ecommerce_flutter/data_model/wishlist_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/middlewares/banned_user.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';

import '../data_model/quantity_response.dart';
import '../helpers/main_helpers.dart';

class WishListRepository {
  Future<dynamic> getUserWishlist() async {
    String url = ("${AppConfig.BASE_URL}/wishlists");
    Map<String, String> header = commonHeader;
    print("print${url}");
    header.addAll(authHeader);
    header.addAll(currencyHeader);
    final response = await ApiRequest.get(
        url: url, headers: header, middleware: BannedUser());
    print("print${response.body}");
    return wishlistResponseFromJson(response.body);
  }

  Future<dynamic> delete({
    int? wishlist_id = 0,
  }) async {
    String url = ("${AppConfig.BASE_URL}/wishlists/${wishlist_id}");

    final response = await ApiRequest.delete(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    return wishlistDeleteResponseFromJson(response.body);
  }

  Future<dynamic> isProductInUserWishList({product_id = 0}) async {
    String url =
        ("${AppConfig.BASE_URL}/wishlists-check-product?product_id=${product_id}");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());

    return wishListChekResponseFromJson(response.body);
  }

  Future<dynamic> add({product_id = 0}) async {
    String url =
        ("${AppConfig.BASE_URL}/wishlists-add-product?product_id=${product_id}");

    // print(url.toString());
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());

    // print(response.body);
    return wishListChekResponseFromJson(response.body);
  }

  Future<dynamic> remove({product_id = 0}) async {
    // print('DP--------------------${product_id}');
    String url =
        ("${AppConfig.BASE_URL}/wishlists-remove-product?product_id=${product_id}");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());

    return wishListChekResponseFromJson(response.body);
  }

  Future<dynamic> quantity({product_id = 0}) async {
    // String url = ("${AppConfig.BASE_URL}/products/size-list/${product_id}");
    String url = ("${AppConfig.BASE_URL}/carts/size-list/${product_id}");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    // print(response.body);
    // print('DP--------------------${response.body}');
    return QuantityResponseFromJson(response.body);
  }

  Future<dynamic> newQuantity({product_id = 0}) async {
    // String url = ("${AppConfig.BASE_URL}/products/new-size-list/${product_id}");
    // print('DP--------------------${product_id}');
    // String url = ("${AppConfig.BASE_URL}/products/size-list/${product_id}");
    String url = ("${AppConfig.BASE_URL}/carts/size-list/${product_id}");
    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    // print('DP--------------------${response.body}');
    return QuantityResponseFromJson(response.body);
  }
}
