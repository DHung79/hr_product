import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JTTextStyle {
  static TextStyle h2Bold({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w700,
      color: color,
      fontSize: 24,
    );
  }

  static TextStyle h4Bold({Color color = Colors.black}) {
    return GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      color: color,
      fontSize: 18,
    );
  }

  static TextStyle headerTitle({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w700,
      color: color,
      fontSize: 16,
    );
  }

  static TextStyle mediumHeaderTitle({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      color: color,
      fontSize: 16,
    );
  }

  static TextStyle normalHeaderTitle({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 16,
    );
  }

  static TextStyle normalHeaderTitleLine({Color color = Colors.black}) {
    return GoogleFonts.lexend(
        fontWeight: FontWeight.w500,
        color: color,
        fontSize: 16,
        textStyle: const TextStyle(decoration: TextDecoration.lineThrough));
  }

  static TextStyle boldBodyText({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w700,
      color: color,
      fontSize: 14,
    );
  }

  static TextStyle mediumBodyText({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      color: color,
      fontSize: 14,
    );
  }

  static TextStyle normalText({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
    );
  }

  static TextStyle link({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle superscript({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
      fontFeatures: [
        const FontFeature.enable('sups'),
      ],
    );
  }

  static TextStyle subMedium({Color color = Colors.black}) {
    return GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      color: color,
      fontSize: 12,
    );
  }

  static TextStyle superSmallText({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 10,
    );
  }
}
