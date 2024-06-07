import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/pricecategory_response.dart';

class PriceCategoryRepository {

  Future<PriceCategoryResponse> getPriceCategories() async {
    String url=("${AppConfig.BASE_URL}/price-ranges");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return priceCategoryResponseFromJson(response.body);
  }

}