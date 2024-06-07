import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/shoescollection_response.dart';

class ShoesCollectionRepository {

  Future<ShoesCollectionResponse> getShoesCollectionCategories() async {
    String url=("${AppConfig.BASE_URL}/shoe-collection");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return shoesCollectionResponseFromJson(response.body);
  }

}