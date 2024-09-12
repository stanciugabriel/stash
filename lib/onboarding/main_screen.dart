import 'package:cardnest/onboarding/get_started.dart';
import 'package:flutter/material.dart';
import 'background_widget.dart'; // Import your background widget
import 'features.dart'; // Import the Features screen

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _showWelcome = true;

  // Toggle between Welcome and Features screens
  void _toggleScreens() {
    setState(() {
      _showWelcome = !_showWelcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _showWelcome
              ? WelcomeScreen(onContinue: _toggleScreens)
              : Features(),
        ),
      ),
    );
  }
}
