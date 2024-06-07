import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/sellermarket_response.dart';

class SellerMarketRepository {

  Future<SellerMarketResponse> getSellerMarketCategories() async {
    String url=("${AppConfig.BASE_URL}/seller-from-market");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return sellerMarketResponseFromJson(response.body);
  }

}