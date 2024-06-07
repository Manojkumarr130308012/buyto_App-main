import 'package:flutter/material.dart';

import '../my_theme.dart';

class MyWidget {
  BuildContext? myContext;
  BuildContext? pop;

  MyWidget({this.myContext});

  BuildContext? getContext() {
    return myContext;
  }

  static Widget imageWithPlaceholder({
    String? url,
    double height = 0.0,
    double elevation = 0.0,
    BoxBorder? border,
    width = 0.0,
    BorderRadiusGeometry radius = BorderRadius.zero,
    BoxFit fit = BoxFit.cover,
    Color backgroundColor = Colors.grey,
  }) {
    return Material(
      color: backgroundColor,
      elevation: elevation,
      borderRadius: radius,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: border ?? Border.all(width: 0, color: MyTheme.noColor),
        ),
        child: url != null && url.isNotEmpty
            ? ClipRRect(
                borderRadius: radius,
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/placeholder.png",
                  image: url,
                  height: height,
                  imageErrorBuilder: (context, object, stackTrace) {
                    return Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        image: const DecorationImage(
                          image: AssetImage("assets/placeholder.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  width: width,
                  fit: fit,
                ),
              )
            : Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  image: const DecorationImage(
                    image: AssetImage("assets/placeholder.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }

  static Widget customCardView(
      {double width = 0.0,
      double elevation = 0.0,
      double blurSize = 20.0,
      double height = 0.0,
      double borderRadius = 0.0,
      Color shadowColor = MyTheme.textfield_grey,
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0),
      Color backgroundColor = const Color.fromRGBO(255, 255, 255, 0),
      Widget? child,
      double borderWidth = 0.0,
      EdgeInsets? padding,
      EdgeInsets? margin,
      Alignment alignment = Alignment.center}) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(0, 6),
            blurRadius: blurSize,
          ),
        ],
      ),
      child: child,
    );
  }
}
