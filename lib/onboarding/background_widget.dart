import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
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
          child,
        ],
      ),
    );
  }
}
