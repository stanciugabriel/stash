import 'package:cardnest/navbar.dart';
import 'package:cardnest/providers/account_provider.dart';
import 'package:cardnest/providers/card_provider.dart';
import 'package:cardnest/providers/locale_provider.dart';
import 'package:cardnest/providers/stores_provider.dart';
import 'package:cardnest/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider(lightTheme);
  await themeProvider.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => StoresProvider()),
      ChangeNotifierProvider(create: (_) => CardProvider()),
      ChangeNotifierProvider(create: (_) => themeProvider),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: const MyApp(),
  ));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const NavBar(
        pageIndex: 0,
      ),
    );
  }
}
