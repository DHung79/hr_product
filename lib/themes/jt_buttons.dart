import 'package:flutter/material.dart';
import 'jt_theme.dart';

class JTButtons {
  static Widget rounded({
    required void Function()? onPressed,
    required Widget child,
    Color? color,
    Color? splashColor,
    double? width,
    double height = 56,
    BorderRadiusGeometry? borderRadius,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) prefixIcon,
            child,
            if (suffixIcon != null) suffixIcon,
          ],
        ),
      ),
    );
  }

  static Widget outline({
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

  static Widget gradient({
    required void Function()? onPressed,
    required Widget child,
    Color? splashColor,
    double? width,
    double height = 56,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    Gradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: border ?? Border.all(color: JTColors.transparent),
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        gradient: gradient,
      ),
      constraints: BoxConstraints(
        maxWidth: width ?? double.infinity,
        minHeight: height,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: splashColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  static Widget backButton({
    required void Function()? onTap,
    required Widget child,
  }) {
    return Row(
      children: [
        InkWell(
          splashColor: JTColors.transparent,
          highlightColor: JTColors.transparent,
          onTap: onTap,
          child: ClipOval(
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                border: Border.all(color: JTColors.n200),
                color: JTColors.nWhite,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgIcon(
                  SvgIcons.arrowBackward,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: child,
        ),
      ],
    );
  }
}
