import 'dart:convert';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/screens/otp.dart';
import 'package:active_ecommerce_flutter/screens/registration.dart';
import 'package:active_ecommerce_flutter/ui_elements/auth_ui.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:toast/toast.dart';
import '../custom/loading.dart';
import '../repositories/address_repository.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "phone"; //phone or email
  String initialCountry = 'IN';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'IN', dialCode: "+91");
  var countries_code = <String?>[];

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
    fetch_country();
  }

  fetch_country() async {
    var data = await AddressRepository().getCountryList();
    data.countries.forEach((c) => countries_code.add(c.code));
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressSendCode() async {
    var mobilepre = '+91';
    var mobile = _phoneNumberController.text.toString();
    var password = _passwordController.text.toString();

    if (mobile == "" && mobile.length != 10) {
      ToastComponent.showDialog(
          // AppLocalizations.of(context)!.enter_phone_number,
          'Enter Mobile Number',
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
    }
    if (mobile.length != 10) {
      ToastComponent.showDialog(
          // AppLocalizations.of(context)!.enter_phone_number,
          'Enter Valid Mobile Number',
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
    } else {
      Loading.show(context);
      // Provider.of<LocaleProvider>(context,listen: false).name();
      // Provider.of<LocaleProvider>(context,listen: false).mobileNo();
      // Provider.of<LocaleProvider>(context,listen: false).profilePhoto();
      var loginResponse = await AuthRepository()
          .getLoginResponse(mobilepre + mobile, password, _login_by);
      Loading.close();

      if (loginResponse.result == false) {
        if (loginResponse.message.runtimeType == List) {
          ToastComponent.showDialog(loginResponse.message!.join("\n"),
              gravity: Toast.bottom, duration: 3);
          return;
        }
        ToastComponent.showDialog(loginResponse.message!.toString(),
            gravity: Toast.bottom, duration: Toast.lengthLong);
      } else {
        // ToastComponent.showDialog(loginResponse.message!,
        // gravity: Toast.bottom, duration: Toast.lengthLong);
        // push notification starts
        if (OtherConfig.USE_PUSH_NOTIFICATION) {
          final FirebaseMessaging _fcm = FirebaseMessaging.instance;
          await _fcm.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
          String? fcmToken = await _fcm.getToken();
          // print(fcmToken);
          if (fcmToken != null) {
            if (is_logged_in.$ == true) {
              var deviceTokenUpdateResponse = await ProfileRepository()
                  .getDeviceTokenUpdateResponse(fcmToken);
            }
          }
        }
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          // return Main();
          return Otp(loginResponse: loginResponse);
        }), (newRoute) => false);
      }
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }
  }

  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MyTheme.white,
        body: Stack(children: [
          Container(
            child: Image.asset(
              "assets/splash_screen_logo.png",
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: _screen_width - 0,
              height: _screen_height / 1.85,
              decoration: BoxDecoration(
                color: MyTheme.light_grey,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 4.0, left: 20.0, top: 40),
                    child: Text(
                      "Mobile Number",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'NotoSans'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5.0, top: 20.0, left: 20.0, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _phoneNumberController,
                          autofocus: false,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: InputDecorations.buildInputDecoration_1(
                            hint_text: "Enter the Mobile Number",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, left: 20.0, right: 30),
                    child: Container(
                      height: 45,
                      width: _screen_width - 50,
                      child: Btn.basic(
                        minWidth: MediaQuery.of(context).size.width,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          "SEND OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSans'),
                        ),
                        onPressed: () {
                          onPressSendCode();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!
                          .login_screen_or_create_new_account,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                          fontFamily: 'NotoSans'),
                    )),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 20.0, right: 30),
                    child: Container(
                      height: 45,
                      width: _screen_width - 50,
                      child: Btn.minWidthFixHeight(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 50,
                        color: MyTheme.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0))),
                        child: Text(
                          AppLocalizations.of(context)!.login_screen_sign_up,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSans'),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Registration();
                          }));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}
