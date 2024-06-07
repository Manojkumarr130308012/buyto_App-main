import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/size_category_response.dart';

class SizeCategoryRepository {

  Future<SizeCategoryResponse> getFilterPageSizeCategory() async {
    String url=("${AppConfig.BASE_URL}/filter/size");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return sizeCategoryResponseFromJson(response.body);
  }

  Future<SizeCategoryResponse> getSizeCategory({name = "", page = 1}) async {
    String url=("${AppConfig.BASE_URL}/filter/size"+
        "?page=${page}&name=${name}");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return sizeCategoryResponseFromJson(response.body);
  }

}