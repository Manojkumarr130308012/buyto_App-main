import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/api-request.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

import '../data_model/slipercollection_response.dart';


class SliperCollectionRepository {

  Future<SliperCollectionResponse> getSliperCollectionCategories() async {
    String url=("${AppConfig.BASE_URL}/slipper-collection");
    final response =
    await ApiRequest.get(url: url,headers: {
      "App-Language": app_language.$!,
    });
    return sliperCollectionResponseFromJson(response.body);
  }

}