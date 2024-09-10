import 'dart:io';
import 'package:cardnest/homepage.dart';
import 'package:cardnest/navbar.dart';
import 'package:cardnest/providers/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CardProvider()),
    // Add other providers here if needed
  ], child: MyApp()));
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      home: NavBar(
        pageIndex: 0,
      ),
    );
  }
}
