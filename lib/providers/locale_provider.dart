
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
class LocaleProvider with ChangeNotifier{

  String _userName='';
  String _mobileNumber='';
  String _profileImage='';
  String get userName=>_userName;
  String get mobileNumber=>_mobileNumber;
  String get profileImage=>profileImage;

  Future<void> name()async{
    _userName=(await AuthRepository().userName())!;
    notifyListeners();
  }

  Future<void> mobileNo()async{
    _mobileNumber=(await AuthRepository().mobileNumber())!;
    notifyListeners();
  }

  Future<void> profilePhoto()async{
    _profileImage=(await AuthRepository().profileImage())!;
    notifyListeners();
  }

  Locale? _locale;
  Locale get locale {
    return _locale = Locale(app_mobile_language.$==''?"en":app_mobile_language.$!,'');
  }


  void setLocale(String code){
    _locale = Locale(code,'');
    notifyListeners();
  }
}