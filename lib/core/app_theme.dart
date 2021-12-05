import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

enum AppTheme {
  DarkTheme,
  LightTheme,
}

// BuildContext context = App.materialKey.currentContext;

final appThemeData = {
  AppTheme.LightTheme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    backgroundColor: Color(0xffF1F5FB),
    indicatorColor: Color(0xffCBDCF8),
    buttonColor: Color(0xffF1F5FB),
    hintColor: Color(0xffEECED3),
    highlightColor: Color(0xffFCE192),
    hoverColor: Color(0xff4285F4),
    focusColor: Color(0xffA8DAB5),
    disabledColor: Colors.grey,
    cardColor: Colors.white,
    canvasColor: Colors.grey[50],
    // appBarTheme:
    //     Theme.of(context).appBarTheme.copyWith(brightness: Brightness.light),
  ),
  AppTheme.DarkTheme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: HexColor("#121212"),
    backgroundColor: HexColor("#121212"),
    indicatorColor: Color(0xff0E1D36),
    buttonColor: Color(0xff3B3B3B),
    hintColor: Color(0xff280C0B),
    highlightColor: Color(0xff372901),
    hoverColor: Color(0xff3A3A3B),
    focusColor: Color(0xff0B2512),
    disabledColor: Colors.grey,
    cardColor: Color(0xFF151515),
    canvasColor: Colors.black,
    primarySwatch: Colors.red,
    // appBarTheme:
    //     Theme.of(context).appBarTheme.copyWith(brightness: Brightness.dark),
  ),
};
