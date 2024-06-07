import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/sub_category_response.dart';

class SubCategoryRepository {

  Future<SubCategoryResponse> getFilterPageSubCategory() async {
    String url=("${AppConfig.BASE_URL}/filter/subcategories");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return subCategoryResponseFromJson(response.body);
  }

  Future<SubCategoryResponse> getSubCategory({name = "", page = 1}) async {
    String url=("${AppConfig.BASE_URL}/filter/subcategories"+
        "?page=${page}&name=${name}");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return subCategoryResponseFromJson(response.body);
  }



}
