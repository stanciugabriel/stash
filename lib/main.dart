import 'dart:io';
import 'package:cardnest/homepage.dart';
import 'package:cardnest/navbar.dart';
import 'package:cardnest/providers/card_provider.dart';
import 'package:cardnest/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ThemeProvider and load the saved theme
  final themeProvider = ThemeProvider(lightTheme); // Use a default theme here
  await themeProvider.initialize(); // Load the saved theme

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CardProvider()),
      ChangeNotifierProvider(create: (_) => themeProvider),
    ],
    child: MyApp(),
  ));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: themeProvider.themeData,
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      home: NavBar(
        pageIndex: 0,
      ),
    );
  }
}
