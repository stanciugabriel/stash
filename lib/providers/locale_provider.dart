import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? locale;

  LocaleProvider() {
    loadLocale();
  }

  loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString('locale');

    switch (localeString) {
      case 'en':
        locale = const Locale('en');
      case 'ro':
        locale = const Locale('ro');
      case '':
        locale = null;
    }
  }

  void setLocale(String newLocale) async {
    locale = Locale(newLocale);
    if (newLocale == '') {
      locale = null;
    }

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('locale', newLocale);

    notifyListeners();
  }
}
