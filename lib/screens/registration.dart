import 'dart:io';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/google_recaptcha.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/other_config.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:validators/validators.dart';
import '../custom/loading.dart';
import '../helpers/file_helper.dart';
import '../repositories/address_repository.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "phone"; //phone or email
  String initialCountry = 'IN';

  PhoneNumber phoneCode = PhoneNumber(isoCode: 'IN', dialCode: "+91");
  var countries_code = <String?>[];

  String? _phone = "";
  bool? _isAgree = false;
  bool _isCaptchaShowing = false;
  String googleRecaptchaKey = "";

  final ImagePicker _picker = ImagePicker();
  XFile? _file;

  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ownerController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

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

  onPressSignUp() async {
    var name = _nameController.text.toString();
    var ownerName = _ownerController.text.toString();
    var email = _emailController.text.toString();
    // var password = _passwordController.text.toString();
    var mobile = _phoneNumberController.text.toString();
    var mobilePrefix = '+91';
    var password = "123456";
    var password_confirm = _passwordConfirmController.text.toString();

    if (name == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_your_name,
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (_register_by == 'email' && (email == "" || !isEmail(email))) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_email,
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (_register_by == 'phone' && mobile == "") {
      ToastComponent.showDialog("Enter Mobile Number",
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (password == "") {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_password,
          gravity: Toast.bottom, duration: Toast.lengthLong);
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!
              .password_must_contain_at_least_6_characters,
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
    } else if (mobile.length < 10) {
      ToastComponent.showDialog('Enter Valid Mobile Number',
          // AppLocalizations.of(context)!
          //     .password_must_contain_at_least_6_characters,
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
    }
    Loading.show(context);
    var signupResponse = await AuthRepository().getSignupResponse(
        name,
        _register_by == 'email' ? email : mobilePrefix + mobile,
        password,
        password_confirm,
        _register_by,
        googleRecaptchaKey);
    Loading.close();
    if (signupResponse.result == false) {
      var message = "";
      signupResponse.message.forEach((value) {
        message += value + "\n";
      });

      ToastComponent.showDialog(message, gravity: Toast.center, duration: 3);
    } else {
      ToastComponent.showDialog(signupResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);
      AuthHelper().setUserData(signupResponse);
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

        if (fcmToken != null) {
          // print("--fcm token--");
          // print(fcmToken);
          if (is_logged_in.$ == true) {
            // update device token
            var deviceTokenUpdateResponse = await ProfileRepository()
                .getDeviceTokenUpdateResponse(fcmToken);
          }
        }
      }

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return Login();
      }), (newRoute) => false);
      // if ((mail_verification_status.$ && _register_by == "email") ||
      //     _register_by == "phone") {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      //     return Otp(
      //       verify_by: _register_by,
      //       user_id: signupResponse.user_id,
      //     );
      //   }));
      // } else {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      //     return Login();
      //   }));
      // }
    }
  }

  chooseAndUploadImage(context) async {
    _file = await _picker.pickImage(source: ImageSource.gallery);
    if (_file == null) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.no_file_is_chosen,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }
    String base64Image = FileHelper.getBase64FormateFile(_file!.path);
    String fileName = _file!.path.split("/").last;

    // var profileImageUpdateResponse =
    // await ProfileRepository().getProfileImageUpdateResponse(
    //   base64Image,
    //   fileName,
    // );

    // if (profileImageUpdateResponse.result == false) {
    //   ToastComponent.showDialog(profileImageUpdateResponse.message,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //   return;
    // } else {
    //   ToastComponent.showDialog(profileImageUpdateResponse.message,
    //       gravity: Toast.center, duration: Toast.lengthLong);
    //
    //   avatar_original.$ = profileImageUpdateResponse.path;
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MyTheme.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  "assets/splash_screen_logo.png",
                  width: _screen_width,
                  height: _screen_height / 4,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: _screen_width - 0,
                    height: _screen_height / 1.35,
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
                            padding: const EdgeInsets.only(
                                bottom: 4.0, left: 20.0, top: 30),
                            child: Text(
                              // AppLocalizations.of(context)!.name_ucf,
                              "Shop Name",
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, left: 20.0, top: 10.0, right: 30),
                            child: Container(
                              height: 45,
                              width: _screen_width,
                              child: TextField(
                                controller: _nameController,
                                autofocus: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hint_text: "Enter the Shop Name"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4.0, left: 20.0, top: 10),
                            child: Text(
                              // AppLocalizations.of(context)!.name_ucf,
                              "Owner Name",
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, left: 20.0, top: 10.0, right: 30),
                            child: Container(
                              height: 45,
                              width: _screen_width,
                              child: TextField(
                                controller: _ownerController,
                                autofocus: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hint_text: "Enter the Owner Name"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 4.0, left: 20.0, top: 10.0),
                            child: Text(
                              "Mobile Number",
                              style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (_register_by == "email")
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 36,
                                    child: TextField(
                                      controller: _emailController,
                                      autofocus: false,
                                      decoration: InputDecorations
                                          .buildInputDecoration_1(
                                              hint_text: "johndoe@example.com"),
                                    ),
                                  ),
                                  otp_addon_installed.$
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _register_by = "phone";
                                            });
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .or_register_with_a_phone,
                                            style: TextStyle(
                                                color: MyTheme.accent_color,
                                                fontStyle: FontStyle.italic,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  top: 10.0,
                                  left: 20.0,
                                  right: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 85,
                                    width: _screen_width,
                                    child: TextField(
                                      controller: _phoneNumberController,
                                      autofocus: false,
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecorations
                                          .buildInputDecoration_1(
                                        hint_text: "Enter the Mobile Number",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 20.0, right: 30),
                            child: Container(
                              height: 45,
                              width: _screen_width - 50,
                              child: Btn.minWidthFixHeight(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 50,
                                color: MyTheme.amber,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0))),
                                child: Text(
                                  "Add to Shop Photo",
                                  style: TextStyle(
                                      color: MyTheme.accent_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'NotoSans'),
                                ),
                                onPressed: () {
                                  chooseAndUploadImage(context);
                                },
                              ),
                            ),
                          ),
                          if (google_recaptcha.$)
                            Container(
                              height: _isCaptchaShowing ? 350 : 50,
                              width: 300,
                              child: Captcha(
                                (keyValue) {
                                  googleRecaptchaKey = keyValue;
                                  setState(() {});
                                },
                                handleCaptcha: (data) {
                                  if (_isCaptchaShowing.toString() != data) {
                                    _isCaptchaShowing = data;
                                    setState(() {});
                                  }
                                },
                                isIOS: Platform.isIOS,
                              ),
                            ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, left: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  child: Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      value: _isAgree,
                                      onChanged: (newValue) {
                                        _isAgree = newValue;
                                        setState(() {});
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    width: DeviceInfo(context).width! - 130,
                                    child: RichText(
                                        maxLines: 2,
                                        text: TextSpan(
                                            style: TextStyle(
                                                color: MyTheme.font_grey,
                                                fontSize: 12),
                                            children: [
                                              TextSpan(
                                                text: "I agree to the",
                                              ),
                                              TextSpan(
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CommonWebviewScreen(
                                                                          page_name:
                                                                              "Terms Conditions",
                                                                          url:
                                                                              "${AppConfig.RAW_BASE_URL}/mobile-page/terms",
                                                                        )));
                                                      },
                                                style: TextStyle(
                                                    color:
                                                        MyTheme.accent_color),
                                                text: " Terms Conditions",
                                              ),
                                              TextSpan(
                                                text: " &",
                                              ),
                                              TextSpan(
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        CommonWebviewScreen(
                                                                          page_name:
                                                                              "Privacy Policy",
                                                                          url:
                                                                              "${AppConfig.RAW_BASE_URL}/mobile-page/privacy-policy",
                                                                        )));
                                                      },
                                                text: " Privacy Policy",
                                                style: TextStyle(
                                                    color:
                                                        MyTheme.accent_color),
                                              )
                                            ])),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 20, right: 30),
                            child: Container(
                              height: 45,
                              child: Btn.minWidthFixHeight(
                                minWidth: MediaQuery.of(context).size.width,
                                height: 50,
                                color: MyTheme.accent_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6.0))),
                                child: Text(
                                  AppLocalizations.of(context)!.sign_up_ucf,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: _isAgree!
                                    ? () {
                                        onPressSignUp();
                                      }
                                    : null,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  AppLocalizations.of(context)!
                                      .already_have_an_account,
                                  style: TextStyle(
                                      color: MyTheme.font_grey, fontSize: 12),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  child: Text(
                                    AppLocalizations.of(context)!.log_in,
                                    style: TextStyle(
                                        color: MyTheme.accent_color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Login();
                                    }));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ])),
              )
            ],
          ),
        ));
  }
}
