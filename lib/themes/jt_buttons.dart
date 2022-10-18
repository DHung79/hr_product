import 'package:flutter/material.dart';

import 'jt_colors.dart';

class JTButtons {
  static Widget rounded({
    required void Function()? onPressed,
    required Widget child,
    Color? color,
    Color? splashColor,
    double? width,
    double height = 56,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: border ?? Border.all(color: JTColors.transparent),
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        maxWidth: width ?? double.infinity,
        minHeight: height,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: splashColor,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
