import 'package:active_ecommerce_flutter/custom/btn.dart';
import 'package:active_ecommerce_flutter/data_model/login_response.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/helpers/system_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Otp extends StatefulWidget {
  String? title;
  LoginResponse? loginResponse;

  Otp({Key? key, this.title, this.loginResponse}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onTapResend() async {
    var resendCodeResponse = await AuthRepository().getResendCodeResponse();

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message!,
          gravity: Toast.bottom, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message!,
          gravity: Toast.bottom, duration: Toast.lengthLong);
    }
  }

  onPressConfirm() async {
    var code = _verificationCodeController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.enter_verification_code,
          gravity: Toast.bottom,
          duration: Toast.lengthLong);
      return;
    }
    print("widget.loginResponse!${widget.loginResponse!}");
    AuthHelper().setUserData(widget.loginResponse!);

    var confirmCodeResponse =
        await AuthRepository().getConfirmCodeResponse(code);

    if (!(confirmCodeResponse.result)) {
      ToastComponent.showDialog(confirmCodeResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);
    } else {
      ToastComponent.showDialog(confirmCodeResponse.message,
          gravity: Toast.bottom, duration: Toast.lengthLong);

      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return Login();
      // }));
      // if (SystemConfig.systemUser != null) {
      //   SystemConfig.systemUser!.emailVerified=true;
      // }

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Main()), (route) => false);
    }
  }

  @override
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 16.0, top: 30.0),
                          child: Container(
                              width: _screen_width * (3 / 4),
                              child: Text(
                                  // AppLocalizations.of(context)!.enter_the_verification_code_that_sent_to_your_phone_recently,
                                  'Enter the verification code that has been sent to your phone',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: MyTheme.dark_grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'NotoSans',
                                      height: 1.5))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, top: 10.0, left: 20, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 45,
                                width: _screen_width,
                                child: TextField(
                                  controller: _verificationCodeController,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "1 2 3 4 5 6"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, top: 10.0, left: 20, right: 30),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.textfield_grey, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: Btn.basic(
                              minWidth: MediaQuery.of(context).size.width,
                              color: MyTheme.accent_color,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0))),
                              child: Text(
                                AppLocalizations.of(context)!.confirm_ucf,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressConfirm();
                              },
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(top: 40),
                        //   child: InkWell(
                        //     onTap: (){
                        //       onTapResend();
                        //     },
                        //     child: Text(AppLocalizations.of(context)!.resend_code_ucf,
                        //         textAlign: TextAlign.center,
                        //         style: TextStyle(
                        //             color: MyTheme.accent_color,
                        //             decoration: TextDecoration.underline,
                        //             fontSize: 13)),
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 20.0, right: 30),
                          child: Container(
                            height: 45,
                            width: _screen_width - 50,
                            child: Btn.minWidthFixHeight(
                              minWidth: MediaQuery.of(context).size.width,
                              height: 50,
                              color: MyTheme.light_grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0))),
                              child: Text(
                                AppLocalizations.of(context)!.resend_code_ucf,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'NotoSans'),
                              ),
                              onPressed: () {
                                onTapResend();
                              },
                            ),
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
                              color: MyTheme.golden.withOpacity(0.7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0))),
                              child: Text(
                                AppLocalizations.of(context)!.logout_ucf,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'NotoSans'),
                              ),
                              onPressed: () {
                                onTapLogout(context);
                              },
                            ),
                          ),
                        ),
                      ])))
        ]));
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Login();
    }), (route) => false);
  }
}
