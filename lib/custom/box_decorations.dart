import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';

class BoxDecorations {
  static BoxDecoration buildBoxDecoration_1({double radius = 6.0}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 5.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildBoxDecoration_2({double radius = 25.0}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 5.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCartCircularButtonDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: Color.fromRGBO(229, 241, 248, 1),
    );
  }

  static BoxDecoration buildCircularButtonDecoration_1() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(36.0),
      color: Colors.white.withOpacity(.80),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCircularButtonDecoration_2() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.white.withOpacity(.80),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(.08),
          blurRadius: 100,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCircularButtonDecoration_3() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(4.0),
      color: MyTheme.accent_color_shadow.withOpacity(.80),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCircularButtonDecoration_4() {
    return BoxDecoration(
      border: Border.all(color: MyTheme.light_grey, width: 2),
      borderRadius: BorderRadius.circular(10.0),
      color: MyTheme.white.withOpacity(0.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCircularButtonDecoration_5() {
    return BoxDecoration(
      border: Border.all(color: MyTheme.light_grey, width: 2),
      borderRadius: BorderRadius.circular(10.0),
      // color: MyTheme.white.withOpacity(0.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 2,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCircularButtonDecoration_6() {
    return BoxDecoration(
      // color: MyTheme.white,
      color: Colors.orange.withOpacity(0.3),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCircularButtonDecoration_7() {
    return BoxDecoration(
      color: MyTheme.accent_color_shadow,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(5.0),
        bottomLeft: Radius.circular(0.0),
        bottomRight: Radius.circular(25.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildCircularButtonDecoration_8() {
    return BoxDecoration(
      color: Colors.lightBlue.withOpacity(0.2),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5.0),
        topRight: Radius.circular(5.0),
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 10.0), // shadow direction: bottom right
        )
      ],
    );
  }

  static BoxDecoration buildBoxDecoration_9({double radius = 6.0}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: MyTheme.accent_color.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: 0.0,
          offset: Offset(0.0, 5.0), // shadow direction: bottom right
        )
      ],
    );
  }

}
