import 'package:flutter/material.dart';

CardTheme cardTheme = const CardTheme(
  shadowColor: Colors.transparent,
  elevation: 2.0,
);

InputDecorationTheme inputDecorationTheme = const InputDecorationTheme(
  border: OutlineInputBorder(),
);


ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blueAccent,
  cardTheme: cardTheme,
  inputDecorationTheme: inputDecorationTheme,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.blueAccent,
  cardTheme: cardTheme,
  inputDecorationTheme: inputDecorationTheme,
);
