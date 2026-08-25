import 'package:flutter/material.dart';

const lightActionBlue = Color(0xFF1967d2);
const lightBackgroundWhite = Color(0xFFf5f5f7);
const lightBackgroundWhiter = Color(0xFFffffff);
const lightDeepOrange = Color(0xFFF5A500);
const lightEnglishColor = Color(0xFFe26511);
const lightErrorColor = Color(0xFFd73a4a);
const lightKanaColor = Color(0xFF6f42c1);
const lightRomajiColor = Color(0xFF35c759);
const lightTextBlack = Color(0xFF15141b);
const lightTextGrey = Color(0xFF4a4a4a);

ThemeData lightTheme() {
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: lightActionBlue),
      backgroundColor: lightDeepOrange,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(
      color: lightBackgroundWhiter,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      brightness: Brightness.light,
      primary: lightKanaColor,
      secondary: lightRomajiColor,
      tertiary: lightEnglishColor,
      surface: lightTextGrey,
      surfaceBright: lightTextBlack,
      surfaceContainer: lightBackgroundWhite,
      surfaceContainerHigh: lightBackgroundWhiter,
      error: lightErrorColor,
    ),
    dialogTheme: const DialogThemeData(backgroundColor: lightBackgroundWhiter),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightActionBlue,
        foregroundColor: lightBackgroundWhiter,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightActionBlue,
    ),
    iconTheme: const IconThemeData(color: lightTextBlack),
    inputDecorationTheme: InputDecorationThemeData(
      labelStyle: TextStyle(color: lightTextGrey),
      fillColor: lightBackgroundWhite,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightTextGrey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 2),
      ),
    ),
    primaryColor: lightActionBlue,
    scaffoldBackgroundColor: lightBackgroundWhite,
    snackBarTheme: const SnackBarThemeData(
      actionTextColor: lightActionBlue,
      backgroundColor: lightBackgroundWhiter,
      contentTextStyle: TextStyle(color: lightTextBlack),
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: lightActionBlue,
    ),
  );
}

const darkActionBlue = Color(0xFF7cacf8);
const darkBackgroundBlack = Color(0xFF212121);
const darkBackgroundBlacker = Color(0xFF121212);
const darkBackgroundBlackest = Color(0xFF000000);
const darkDeepPurple = Colors.deepPurple;
const darkEnglishColor = Color(0xFFff9003);
const darkErrorColor = Color(0xFFff7b72);
const darkKanaColor = Color(0xFFb87cf8);
const darkRomajiColor = Color(0xFF7cf8c6);
const darkTextGrey = Color(0xFFa6a6a6);
const darkTextWhite = Color(0xFFe8e8e8);

ThemeData darkTheme() {
  return ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: darkActionBlue),
      backgroundColor: darkDeepPurple,
    ),
    bottomAppBarTheme: const BottomAppBarThemeData(color: darkBackgroundBlack),
    colorScheme: const ColorScheme.dark().copyWith(
      brightness: Brightness.dark,
      primary: darkKanaColor,
      secondary: darkRomajiColor,
      tertiary: darkEnglishColor,
      surface: darkTextGrey,
      surfaceBright: darkTextWhite,
      surfaceContainer: darkBackgroundBlack,
      surfaceContainerHigh: darkBackgroundBlacker,
      error: darkErrorColor,
    ),
    dialogTheme: const DialogThemeData(backgroundColor: darkBackgroundBlackest),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkActionBlue,
        foregroundColor: darkBackgroundBlackest,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkActionBlue,
    ),
    iconTheme: const IconThemeData(color: darkTextWhite),
    inputDecorationTheme: InputDecorationThemeData(
      labelStyle: TextStyle(color: darkTextGrey),
      fillColor: darkBackgroundBlack,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkTextGrey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 2),
      ),
    ),
    primaryColor: darkActionBlue,
    scaffoldBackgroundColor: darkBackgroundBlacker,
    snackBarTheme: const SnackBarThemeData(
      actionTextColor: darkActionBlue,
      backgroundColor: darkBackgroundBlack,
      contentTextStyle: TextStyle(color: darkTextGrey),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: darkActionBlue,
    ),
  );
}
