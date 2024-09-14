import 'package:Stash/navbar.dart';
import 'package:Stash/onboarding/main_screen.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/card_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:Stash/providers/locale_provider.dart';
import 'package:Stash/providers/stores_provider.dart';
import 'package:Stash/providers/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider(lightTheme);
  await themeProvider.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => StoresProvider()),
      ChangeNotifierProvider(create: (_) => FidelityCardsProvider()),
      ChangeNotifierProvider(create: (_) => CardProvider()),
      ChangeNotifierProvider(create: (_) => themeProvider),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: const MyApp(),
  ));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus(); // Check onboarding status on start
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? finishedOnboarding = prefs.getBool('finishedOnboarding');
    setState(() {
      _showOnboarding = finishedOnboarding == null || !finishedOnboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: themeProvider.themeData.primaryColorDark,
        systemNavigationBarColor: themeProvider.themeData.primaryColorDark,
        statusBarIconBrightness:
            themeProvider.themeData.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: MaterialApp(
        theme: themeProvider.themeData,
        navigatorObservers: [routeObserver],
        locale: localeProvider.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: _showOnboarding ? MainScreen() : const NavBar(pageIndex: 0),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
