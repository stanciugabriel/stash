import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpgradeModal extends StatefulWidget {
  const UpgradeModal({super.key});

  @override
  State<UpgradeModal> createState() => _UpgradeModal();

  static void show(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9),
            topRight: Radius.circular(9),
          ),
        ),
        builder: (BuildContext context) {
          return const UpgradeModal();
        });
  }
}

class _UpgradeModal extends State<UpgradeModal> {
  bool switchValue = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(CupertinoIcons.chevron_back)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          RadiantGradientMask(
            child: Icon(
              CupertinoIcons.sparkles,
              size: 100,
              color: Colors.white,
            ),
          ),
          Text(
            "Get Stash Plus",
            style: TextStyle(
                fontFamily: "SFProDisplay",
                fontSize: 36,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Text(
              "Unlock all premium features with a one-time payment",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 132, 132, 132)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: const Color.fromARGB(255, 216, 216, 216))),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark,
                        color: const Color.fromARGB(255, 3, 68, 230),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Secure Cloud Backup",
                        style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark,
                        color: const Color.fromARGB(255, 3, 68, 230),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Send cards easly via link",
                        style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark,
                        color: const Color.fromARGB(255, 3, 68, 230),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Be the first to get new features",
                        style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 68, 230),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Upgrade to Plus",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "One-time purchase of ",
                style: TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                "24,99 RON.",
                style: TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [Color.fromARGB(255, 3, 68, 230), Colors.blue],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
