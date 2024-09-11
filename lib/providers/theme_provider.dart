import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  String _selectedScheme = 'System';

  bool get isDarkMode => _themeData == ThemeData.dark();

  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;
  String get selectedScheme => _selectedScheme;

  static const String _themeKey = 'theme_mode';

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString(_themeKey) ?? 'System';

    final brightness = SchedulerBinding.instance.window.platformBrightness;
    if (themeMode == 'Dark') {
      _themeData = darkTheme;
    } else if (themeMode == 'Light') {
      _themeData = lightTheme;
    } else {
      _themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
    }
    notifyListeners();
  }

  Future<void> setSystemTheme() async {
    final brightness = SchedulerBinding.instance.window.platformBrightness;
    _themeData = brightness == Brightness.dark ? darkTheme : lightTheme;
    _selectedScheme = 'System';
    await _saveTheme('System');
    notifyListeners();
  }

  Future<void> setLightTheme() async {
    _themeData = lightTheme;
    _selectedScheme = 'Light';
    await _saveTheme('Light');
    notifyListeners();
  }

  Future<void> setDarkTheme() async {
    _themeData = darkTheme;
    _selectedScheme = 'Dark';
    await _saveTheme('Dark');
    notifyListeners();
  }

  Future<void> _saveTheme(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode);
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  primaryColorDark: Colors.white,
  shadowColor: Color(0xFFE5E2E2),
  disabledColor: Colors.white, //used for navbar
  scaffoldBackgroundColor: Colors.white,
  cardColor: Color(0xFF4E4E4E),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black,
  shadowColor: Color(0xFF141414),
  disabledColor: Color(0xFF141414),
  scaffoldBackgroundColor: Colors.black,
  cardColor: Color(0xFF545357), //used for text on grey background
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xFF141414)),
);
