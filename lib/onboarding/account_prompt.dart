import 'package:flutter/material.dart';

class AccountPrompt extends StatelessWidget {
  const AccountPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 45),
          Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: const Text(
                "Stash is Better with an Account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.2,
                  fontFamily: "SFProDisplay",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: const Text(
                "Create an account to unlock all features, or continue without one.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.4,
                  fontFamily: "SFProDisplay",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          // Sign Up Button
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create an account",
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Continue without an account",
            style: TextStyle(
              fontFamily: "SFProDisplay",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
