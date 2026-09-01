import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xff9cd5ff),
    fontFamily: 'Poppins',
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: Color(0xff046ef4),
      onPrimary: Colors.white,
      secondary: Color(0xff077eff),
      onSecondary: Colors.white,
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
      decorationColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black),
      hintStyle: TextStyle(color: Colors.black),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xff8b8b8b)),
    titleTextStyle: TextStyle(color: Color(0xff8b8b8b), fontSize: 18),
  );
}
