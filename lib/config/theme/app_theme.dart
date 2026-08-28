import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Color(0xff9cd5ff),
    fontFamily: 'Poppins',
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
