import 'package:flutter/material.dart';
import 'jt_theme.dart';

class JTDivider {
  static Widget or() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1,
          width: 61,
          color: JTColors.n500,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Text(
            'Hoặc',
            style: JTTextStyle.normalText(color: JTColors.n500),
          ),
        ),
        Container(
          height: 1,
          width: 61,
          color: JTColors.n500,
        ),
      ],
    );
  }
}
