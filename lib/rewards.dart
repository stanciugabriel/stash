import 'package:cardnest/add_card_name.dart';
import 'package:cardnest/alert_box.dart';
import 'package:cardnest/card_modal.dart';
import 'package:cardnest/homepage.dart';
import 'package:cardnest/scan_modal.dart';
import 'package:cardnest/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  State<Rewards> createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedMeshGradient(
              colors: [
                Color.fromARGB(255, 192, 160, 248),
                Color.fromARGB(255, 76, 164, 252),
                Color.fromARGB(255, 255, 187, 228),
                Color(0xFFD9FDFF),
              ],
              options: AnimatedMeshGradientOptions(speed: 3),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/icons/stars.svg"),
                Text(
                  "Coming Soon.",
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SFProDisplay',
                      color: Colors.white),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  child: Text(
                    "In the meantime, subscribe to receive updates when we add new features.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SFProDisplay',
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                AnimatedSubscribeButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedSubscribeButton extends StatefulWidget {
  @override
  _AnimatedSubscribeButtonState createState() =>
      _AnimatedSubscribeButtonState();
}

class _AnimatedSubscribeButtonState extends State<AnimatedSubscribeButton>
    with SingleTickerProviderStateMixin {
  bool _isSubscribed = false;
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
    _colorAnimation = ColorTween(begin: Colors.white, end: Colors.grey[300])
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!_isSubscribed) {
      Haptics.vibrate(HapticsType.success);
      setState(() {
        _isPressed = true;
        _isSubscribed = true;
      });
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_scaleAnimation.value),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: _colorAnimation.value,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              spreadRadius: -7,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isSubscribed)
                Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.green,
                )
              else
                Icon(CupertinoIcons.bell, color: Color(0xFF494949)),
              SizedBox(width: 10),
              Text(
                _isSubscribed ? "Subscribed" : "Subscribe",
                style: TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF494949),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
