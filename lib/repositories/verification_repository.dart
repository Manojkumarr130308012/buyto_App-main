import 'package:active_ecommerce_flutter/data_model/verification_response.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../custom/toast_component.dart';
import '../data_model/verification_response.dart';
import '../helpers/shared_value_helper.dart';

class Verifications {
  Future verification(verify verify) async {
    try {
      final response = await http.post(
          Uri.parse('https://buyto.in/admin/api/v2/update_gst_details'),
          body: verify.toJson(),
          headers: {
            'System-key': '123456',
            "Authorization": "Bearer ${access_token.$}",
            "App-Language": app_language.$!,
          });
      if (response.statusCode == 200) {
        ToastComponent.showDialog('GST Number Updated Successfully',
            gravity: Toast.bottom, duration: Toast.lengthLong);
      } else {
        ToastComponent.showDialog('GST Number Not Updated Successfully',
            gravity: Toast.bottom, duration: Toast.lengthLong);
      }
    } catch (error) {
      // print(error);
    }
  }
}

class BankDetailsRepository {
  Future bankVerification(bankdetailsverify bankdetailsverify) async {
    try {
      final response = await http.post(
          Uri.parse('https://buyto.in/admin/api/v2/update_bank_details'),
          body: bankdetailsverify.toJson(),
          headers: {
            'System-key': '123456',
            "Authorization": "Bearer ${access_token.$}",
            "App-Language": app_language.$!,
          });
      if (response.statusCode == 200) {
        ToastComponent.showDialog('Bank Details Updated Successfully',
            gravity: Toast.bottom, duration: Toast.lengthLong);
      } else {
        ToastComponent.showDialog('Bank Details Updated Not Successfully',
            gravity: Toast.bottom, duration: Toast.lengthLong);
      }
    } catch (error) {
      print(error);
    }
  }
}

class DocumentVerifyRepository {
  Future documentVerify(documentverify documentverify) async {
    try {
      final response = await http.post(
          Uri.parse('https://buyto.in/admin/api/v2/update_document_details'),
          body:documentverify.toJSon(),
          headers: {
            'System-key': '123456',
            "Authorization": "Bearer ${access_token.$}",
            "App-Language": app_language.$!,
          });
      if (response.statusCode == 200) {
        ToastComponent.showDialog('Document Details Updated Successfully',
            gravity: Toast.bottom, duration: Toast.lengthLong);
      } else {
        ToastComponent.showDialog('Document Details Updated Not Successfully',
            gravity: Toast.bottom, duration: Toast.lengthLong);
      }
    } catch (error) {
      print(error);
    }
  }
}
