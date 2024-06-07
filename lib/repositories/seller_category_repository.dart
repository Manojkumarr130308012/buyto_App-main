import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/seller_category_response.dart';

class SellerCategoryRepository {

  Future<SellerCategoryResponse> getFilterPageSellerCategory() async {
    String url=("${AppConfig.BASE_URL}/filter/seller");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return sellerCategoryResponseFromJson(response.body);
  }

  Future<SellerCategoryResponse> getSellerCategory({name = "", page = 1}) async {
    String url=("${AppConfig.BASE_URL}/filter/seller"+
        "?page=${page}&name=${name}");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return sellerCategoryResponseFromJson(response.body);
  }



}
