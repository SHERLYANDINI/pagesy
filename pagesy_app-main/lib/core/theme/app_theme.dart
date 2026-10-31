import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF2563EB);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark),
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}
