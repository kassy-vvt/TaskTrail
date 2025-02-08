import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}

class AppTheme {
  static TextTheme getTextTheme(ThemeType type) {
    const lightTextStyle = TextStyle(color: Colors.black);
    const darkTextStyle = TextStyle(color: Colors.white);
    switch (type) {
      case ThemeType.light:
        return const TextTheme(
          titleLarge: lightTextStyle,
          titleMedium: lightTextStyle,
          titleSmall: lightTextStyle,
          bodyLarge: lightTextStyle,
          bodyMedium: lightTextStyle,
        );
      case ThemeType.dark:
        return const TextTheme(
          titleLarge: darkTextStyle,
          titleMedium: darkTextStyle,
          titleSmall: darkTextStyle,
          bodyLarge: darkTextStyle,
          bodyMedium: darkTextStyle,
        );
    }
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    primarySwatch: Colors.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: getTextTheme(ThemeType.light),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    primarySwatch: Colors.blue,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: getTextTheme(ThemeType.dark),
  );
}
