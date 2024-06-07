import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';

class TextStyles {
  static TextStyle buildAppBarTexStyle() {
    return TextStyle(fontSize: 16, color: MyTheme.white,fontWeight: FontWeight.w700,fontFamily: 'NotoSans');
  }

  static TextStyle largeTitleTexStyle() {
    return TextStyle(fontSize: 16, color: MyTheme.dark_font_grey,fontWeight: FontWeight.w700, fontFamily: 'NotoSans');
  }

  static TextStyle smallTitleTexStyle() {
    return TextStyle(fontSize: 16, color: MyTheme.dark_font_grey,fontWeight: FontWeight.w500, fontFamily: 'NotoSans', height:1.5);
  }

  static TextStyle verySmallTitleTexStyle() {
    return TextStyle(fontSize: 10, color: MyTheme.dark_font_grey,fontWeight: FontWeight.normal, fontFamily: 'NotoSans');
  }

  static TextStyle largeBoldAccentTexStyle() {
    return TextStyle(fontSize: 16, color: MyTheme.accent_color,fontWeight: FontWeight.w700, fontFamily: 'NotoSans');
  }

  static TextStyle smallBoldAccentTexStyle() {
    return TextStyle(fontSize: 13, color: MyTheme.accent_color,fontWeight: FontWeight.w700, fontFamily: 'NotoSans');
  }

}
