import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';

class AuthScreen {
  static Widget buildScreen(
      BuildContext context, String headerText, Widget child) {
    return Directionality(
      textDirection:
          app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: DeviceInfo(context).height! / 3,
              width: DeviceInfo(context).width,
              color: MyTheme.accent_color,
              alignment: Alignment.bottomCenter,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: CustomScrollView(
                //controller: _mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: Row(
                            children: [
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                    // color: MyTheme.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.asset(
                                    'assets/splash_screen_logo.png'),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                        // Padding(
                        //   padding:  EdgeInsets.only(bottom: 20.0, top: 10,right: MediaQuery.sizeOf(context).width*0.6),
                        //   child: Text(
                        //     // headerText,
                        //     "",
                        //     style: TextStyle(
                        //         color: MyTheme.white,
                        //         fontSize: 18,
                        //         fontWeight: FontWeight.w600),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(vertical: 20),
                        //     decoration:
                        //         BoxDecorations.buildBoxDecoration_1(radius: 16),
                        //     child: child,
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
