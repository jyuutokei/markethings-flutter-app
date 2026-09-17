import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

ThemeData theme() {
  final themeData = ThemeData(
    scaffoldBackgroundColor: const Color(0xff9cd5ff),
    fontFamily: 'Poppins',
    colorScheme: ThemeData.light().colorScheme.copyWith(
      primary: const Color(0xff046ef4),
      secondary: const Color(0xff077eff),
      onError: const Color(0xffd32f2f),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
      decorationColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      hintStyle: const TextStyle(color: Colors.black),
      prefixIconColor: const Color(0xff8b8b8b),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xff046ef4), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffd32f2f)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xffd32f2f), width: 2),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff046ef4),
        foregroundColor: Colors.white,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(color: Color(0xff046ef4));
        }

        return const TextStyle(color: Colors.black);
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Color(0xff046ef4));
        }

        return const IconThemeData(color: Colors.black);
      }),
    ),
    extensions: const [
      MaterialPinThemeExtension(
        theme: MaterialPinTheme(
          shape: MaterialPinShape.outlined,
          cellSize: Size(36, 44),
          spacing: 12,
          entryAnimation: MaterialPinAnimation.scale,
          animationDuration: Duration(milliseconds: 150),
          animationCurve: Curves.easeOut,
          enableErrorShake: true,
          errorAnimationDuration: Duration(milliseconds: 300),
        ),
      ),
    ],
  );
  return themeData;
}
