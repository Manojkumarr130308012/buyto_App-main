import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/sole_category_response.dart';
import '../data_model/sub_category_response.dart';

class SoleCategoryRepository {

  Future<SoleCategoryResponse> getFilterPageSoleCategory() async {
    String url=("${AppConfig.BASE_URL}/filter/sole");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return soleCategoryResponseFromJson(response.body);
  }

  Future<SoleCategoryResponse> getSoleCategory({name = "", page = 1}) async {
    String url=("${AppConfig.BASE_URL}/filter/sole"+
        "?page=${page}&name=${name}");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return soleCategoryResponseFromJson(response.body);
  }



}
