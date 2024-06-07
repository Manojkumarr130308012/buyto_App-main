import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/gender_category_response.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class GenderCategoryRepository {

  Future<GenderCategoryResponse> getFilterPageGenderCategory() async {
    String url=("${AppConfig.BASE_URL}/filter/gender");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return genderCategoryResponseFromJson(response.body);
  }

  Future<GenderCategoryResponse> getGenderCategory({name = "", page = 1}) async {
    String url=("${AppConfig.BASE_URL}/filter/gender"+
        "?page=${page}&name=${name}");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return genderCategoryResponseFromJson(response.body);
  }



}
