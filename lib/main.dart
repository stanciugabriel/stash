import 'dart:io';
import 'package:cardnest/homepage.dart';
import 'package:cardnest/navbar.dart';
import 'package:cardnest/providers/card_provider.dart';
import 'package:cardnest/providers/locale_provider.dart';
import 'package:cardnest/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider(lightTheme);
  await themeProvider.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CardProvider()),
      ChangeNotifierProvider(create: (_) => themeProvider),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: MyApp(),
  ));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      theme: themeProvider.themeData,
      navigatorObservers: [routeObserver],
      locale: localeProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: NavBar(
        pageIndex: 0,
      ),
    );
  }
}
