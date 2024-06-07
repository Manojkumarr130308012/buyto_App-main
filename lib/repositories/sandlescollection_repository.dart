import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/sandlescollection_response.dart';


class SandlesCollectionRepository {

  Future<SandlesCollectionResponse> getSandlesCollectionCategories() async {
    String url=("${AppConfig.BASE_URL}/sandle-type");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return sandlesCollectionResponseFromJson(response.body);
  }

}