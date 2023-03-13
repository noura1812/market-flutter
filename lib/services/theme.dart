import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color base5 = Color(0xff1D3557);
const Color base2 = Color(0xff457B9D);
const Color base3 = Color(0xFFA8DADC);
const Color base4 = Colors.white;
const Color base = Color(0xFFE63946);
const Color base1 = Color(0xFFEBEBEB);

const primaryClr = base;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    shadowColor: base5,
    primaryColor: base2,
    splashColor: base5,
    backgroundColor: base4,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get headingstyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    color: base4,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subheadingstyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? base4 : base5,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get titlestyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? base4 : base5,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get Subtitle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? base4 : Colors.grey,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  ));
}

TextStyle get bodystyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    color: Get.isDarkMode ? base4 : Colors.grey,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  ));
}
