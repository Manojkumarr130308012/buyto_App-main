import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/color_category_response.dart';

class ColorCategoryRepository {

  Future<ColorCategoryResponse> getFilterPageColorCategory() async {
    String url=("${AppConfig.BASE_URL}/filter/color");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return colorCategoryResponseFromJson(response.body);
  }

  Future<ColorCategoryResponse> getColorCategory({name = "", page = 1}) async {
    String url=("${AppConfig.BASE_URL}/filter/color"+
        "?page=${page}&name=${name}");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return colorCategoryResponseFromJson(response.body);
  }



}
