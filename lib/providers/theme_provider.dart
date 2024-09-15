import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData themeData = lightTheme;
  String selectedScheme = 'System';

  static const String _themeKey = 'theme_mode';

  ThemeProvider() {
    initialize();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    selectedScheme = prefs.getString(_themeKey) ?? 'System';

    // final brightness = SchedulerBinding.instance.window.platformBrightness;
    if (selectedScheme == 'Dark') {
      themeData = darkTheme;
    } else if (selectedScheme == 'Light') {
      themeData = lightTheme;
    } else {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
    }
    notifyListeners();
  }

  Future<void> setSystemTheme() async {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
    selectedScheme = 'System';
    await saveTheme();
    notifyListeners();
  }

  Future<void> setLightTheme() async {
    themeData = lightTheme;
    selectedScheme = 'Light';
    await saveTheme();
    notifyListeners();
  }

  Future<void> setDarkTheme() async {
    themeData = darkTheme;
    selectedScheme = 'Dark';
    await saveTheme();
    notifyListeners();
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, selectedScheme);
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  primaryColorDark: Colors.white,
  shadowColor: const Color(0xFFE5E2E2),
  disabledColor: Colors.white, //used for navbar
  scaffoldBackgroundColor: Colors.white,
  cardColor: const Color(0xFF4E4E4E),
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
  dividerColor: const Color(0xFF757575),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black,
  shadowColor: const Color(0xFF141414),
  disabledColor: const Color(0xFF141414),
  scaffoldBackgroundColor: Colors.black,
  cardColor: const Color(0xFF545357), //used for text on grey background
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: Color(0xFF141414)),
  dividerColor: Colors.black,
);
