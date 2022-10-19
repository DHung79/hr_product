import 'package:flutter/material.dart';

class JTColors {
  static Color pPurple = hexToColor('#8350C3');
  static Color pBlue = hexToColor('#6E4CF8');
  static List<Color> pGradient = [
    JTColors.pPurple,
    JTColors.pBlue,
  ];
  static Gradient gradientHorizontal = LinearGradient(
    colors: JTColors.pGradient,
  );
  static Gradient gradientVertical = LinearGradient(
    colors: JTColors.pGradient,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static Color sLightPurple = hexToColor('#9E85E7');
  static Color sDarkPurple = hexToColor('#6D2996');

  static Color nBlack = hexToColor('#1F2433');
  static Color n800 = hexToColor('#393F52');
  static Color n600 = hexToColor('#606679');
  static Color n500 = hexToColor('#A4A9B8');
  static Color n300 = hexToColor('#D6D7DD');
  static Color n200 = hexToColor('#E7EAF2');
  static Color nDisable = hexToColor('#F2F2F2');
  static Color nBackground = hexToColor('#F9F9FF');
  static Color nWhite = hexToColor('#FFFFFF');

  static Color sysLightAlert = hexToColor('#F55858');
  static Color sysDarkAlert = hexToColor('#BA4343');
  static Color sysLightAction = hexToColor('#4D87FA');
  static Color sysDarkAction = hexToColor('#3D6AC4');
  static Color sysLightWarning = hexToColor('#E9A743');
  static Color sysDarkWarning = hexToColor('#A66930');
  static Color oGreen1 = hexToColor('#3FB483');
  static Color oGreen2 = hexToColor('#3DD990');
  static Color oGreen3 = hexToColor('#EDF7F9');
  static Color transparent = Colors.transparent;
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
