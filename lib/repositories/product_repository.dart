import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/classified_ads_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/classified_ads_response.dart';
import 'package:active_ecommerce_flutter/data_model/common_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_details_response.dart';
import 'package:active_ecommerce_flutter/data_model/product_mini_response.dart';
import 'package:active_ecommerce_flutter/data_model/variant_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';

import '../data_model/variant_price_response.dart';

class ProductRepository {
  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/featured?page=${page}");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Result1 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/best-seller");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Currency-Code": SystemConfig.systemCurrency!.code!,
      "Currency-Exchange-Rate":
          SystemConfig.systemCurrency!.exchangeRate.toString(),
    });
    // print("Result2 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getInHouseProducts({page}) async {
    String url = ("${AppConfig.BASE_URL}/products/inhouse?page=$page");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Result3 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/todays-deal");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Result4 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Result5 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {int? id = 0, name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/category/" +
        id.toString() +
        "?page=${page}&name=${name}");
    print("Resulturl6 : " + url);

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Result6 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProductsById(
      {int? id = 0, name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/category/" +
        id.toString() +
        "?page=${page}");
    print("Resulturl6 : " + url);

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Result6 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {int? id = 0, name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=${page}&name=${name}");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Result7 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {int? id = 0, name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/brand/" +
        id.toString() +
        "?page=${page}&name=${name}");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print(url.toString());
    // print("Result8 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      subcategories = "",
      sole = "",
      color = "",
      seller = "",
      gender = "",
      min = "",
      max = ""}) async {
    // String url = ("${AppConfig.BASE_URL}/products/search" +
    //     "?page=${page}&name=${name}&sort_key=${sort_key}&brands=${brands}&categories=${categories}&min=${min}&max=${max}");

    String url = ("${AppConfig.BASE_URL}/products/search" +
        "?page=${page}&name=${name}&sort_key=${sort_key}&brands=${brands}&subcategories=${subcategories}&sole=${sole}&color=${color}&seller=${seller}&gender=${gender}&categories=${categories}&min=${min}&max=${max}");

    // print(url.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Result9 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getDigitalProducts({
    page = 1,
  }) async {
    String url = ("${AppConfig.BASE_URL}/products/digital?page=$page");
    // print(url.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print(response.body);
    // print("Result10 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ClassifiedAdsResponse> getClassifiedProducts({
    page = 1,
  }) async {
    String url = ("${AppConfig.BASE_URL}/classified/all?page=$page");
    // print(url.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print(response.body);
    // print("Result11 : " + response.body);
    return classifiedAdsResponseFromJson(response.body);
  }

  Future<ClassifiedAdsResponse> getOwnClassifiedProducts({
    page = 1,
  }) async {
    String url = ("${AppConfig.BASE_URL}/classified/own-products?page=$page");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    });
    // print(response.body);
    // print("Result12 : " + response.body);
    return classifiedAdsResponseFromJson(response.body);
  }

  Future<ClassifiedAdsResponse> getClassifiedOtherAds({
    id = 1,
  }) async {
    String url = ("${AppConfig.BASE_URL}/classified/related-products/$id");
    // print(url.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print(response.body);
    // print("Result13 : " + response.body);
    return classifiedAdsResponseFromJson(response.body);
  }

  Future<ClassifiedAdsDetailsResponse> getClassifiedProductsDetails(id) async {
    String url = ("${AppConfig.BASE_URL}/classified/product-details/$id");
    // print(url.toString());

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print(response.body);
    // print("Result14 : " + response.body);
    return classifiedAdsDetailsResponseFromJson(response.body);
  }

  Future<CommonResponse> getDeleteClassifiedProductResponse(id) async {
    String url = ("${AppConfig.BASE_URL}/classified/delete/$id");
    // print(url.toString());

    final response = await ApiRequest.delete(url: url, headers: {
      "App-Language": app_language.$!,
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
    });
    // print("Result15 : " + response.body);
    return commonResponseFromJson(response.body);
  }

  Future<CommonResponse> getStatusChangeClassifiedProductResponse(
      id, status) async {
    String url = ("${AppConfig.BASE_URL}/classified/change-status/$id");

    var post_body = jsonEncode({"status": status});
    final response = await ApiRequest.post(
      url: url,
      headers: {
        "App-Language": app_language.$!,
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
      },
      body: post_body,
    );
    // print("Result16 : " + response.body);
    return commonResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getProductDetails({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/products/" + id.toString());
    // print(url.toString());
    // print(SystemConfig.systemCurrency!.code.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Result : " + response.body);
    // print("Result17 : " + response.body);
    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getDigitalProductDetails({int id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/products/" + id.toString());
    // print(url.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    //print(response.body.toString());
    // print("Result18 : " + response.body);
    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getRelatedProducts({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/products/related/" + id.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    // print("Result18 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts(
      {int? id = 0}) async {
    // String url =
    //     ("${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString());
    String url = ("${AppConfig.BASE_URL}/products/top-selling-by-seller/" +
        id.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    // print("top selling product url ${url.toString()}");
    // print("top selling product ${response.body.toString()}");
    // print("Result19 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int? id = 0, color = '', variants = '', qty = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/variant/price");

    var postBody = jsonEncode({
      'id': id.toString(),
      "color": color,
      "variants": variants,
      "quantity": qty
    });

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "App-Language": app_language.$!,
          "Content-Type": "application/json",
        },
        body: postBody);
    // print("Result20 : " + response.body);
    return variantResponseFromJson(response.body);
  }

  Future<VariantPriceResponse> getVariantPrice({id, quantity}) async {
    String url = ("${AppConfig.BASE_URL}/varient-price");

    var post_body = jsonEncode({"id": id, "quantity": quantity});

    // print(url.toString());
    // print(post_body.toString());
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "App-Language": app_language.$!,
          "Content-Type": "application/json",
        },
        body: post_body);
    // print("Result  : " + response.body);
    return variantPriceResponseFromJson(response.body);
  }

  Future<String> getColorDetails({int id = 0}) async {
    String url =
        ("${AppConfig.BASE_URL}/products/related-colors/" + id.toString());
    // print(url.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return response.body;
    print("Result22 : " + response.body);
    // return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getSellerFromMarket(
      {int? id = 0, page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/seller_from_market/" +
        id.toString() +
        "?page=${page}");
    print("Result23 : " + url);
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Result23 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getPriceCategory({int? id = 0, page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/price_range/" +
        id.toString() +
        "?page=${page}");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Result23 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getSandleCategory({int? id = 0}) async {
    String url =
        ("${AppConfig.BASE_URL}/products/sandel_type/" + id.toString());
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    print("Result23 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getAllProducts() async {
    String url = ("${AppConfig.BASE_URL}/products-new");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
      "Currency-Code": SystemConfig.systemCurrency!.code!,
      "Currency-Exchange-Rate":
          SystemConfig.systemCurrency!.exchangeRate.toString(),
    });
    // print("Result24 : " + response.body);
    return productMiniResponseFromJson(response.body);
  }
}
