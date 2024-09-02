import 'package:cardnest/cardlistpage.dart';
import 'package:cardnest/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
