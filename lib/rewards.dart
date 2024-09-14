import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedMeshGradient(
              colors: const [
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
                SvgPicture.asset(
                  "assets/icons/stars.svg",
                  color: Theme.of(context).primaryColorDark,
                ),
                Text(
                  AppLocalizations.of(context)!.coming_soon,
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SFProDisplay',
                      color: Theme.of(context).primaryColorDark),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  child: Text(
                    AppLocalizations.of(context)!.coming_soon_description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SFProDisplay',
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const AnimatedSubscribeButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedSubscribeButton extends StatefulWidget {
  const AnimatedSubscribeButton({super.key});

  @override
  _AnimatedSubscribeButtonState createState() =>
      _AnimatedSubscribeButtonState();
}

class _AnimatedSubscribeButtonState extends State<AnimatedSubscribeButton>
    with SingleTickerProviderStateMixin {
  bool _isSubscribed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  // late Animation<Color?> _colorAnimation;

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
    // _colorAnimation = ColorTween(begin: Colors.white, end: Colors.grey[300])
    //     .animate(_controller);
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
          color: Theme.of(context).disabledColor,
          boxShadow: const [
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
                const Icon(
                  CupertinoIcons.check_mark,
                  color: Colors.green,
                )
              else
                Icon(
                  CupertinoIcons.bell,
                  color: Theme.of(context).primaryColor,
                ),
              const SizedBox(width: 10),
              Text(
                _isSubscribed
                    ? AppLocalizations.of(context)!.subscribed
                    : AppLocalizations.of(context)!.subscribe,
                style: TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
