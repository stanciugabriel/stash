import 'package:cardnest/appearance_modal.dart';
import 'package:cardnest/notifications_modal.dart';
import 'package:cardnest/terms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  final InAppReview inAppReview = InAppReview.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/icons/profile.svg"),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gabriel Stanciu",
                        style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Account settings",
                            style: TextStyle(
                                fontFamily: "SFProDisplay",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6F6F6F)),
                          ),
                          Icon(
                            CupertinoIcons.forward,
                            color: Color(0xFF6F6F6F),
                            size: 16,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text("Preferences",
                  style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6F6F6F),
                  )),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                  onTap: () {
                    NotificationsModal.show(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.bell,
                            size: 30,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Notifications",
                              style: TextStyle(
                                fontFamily: "SFProDisplay",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ))
                        ],
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                  onTap: () {
                    AppearanceModal.show(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.paintbrush,
                            size: 30,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Appearance",
                              style: TextStyle(
                                fontFamily: "SFProDisplay",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ))
                        ],
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Resources",
                  style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6F6F6F),
                  )),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.ellipses_bubble,
                          size: 30,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Leave feedback",
                            style: TextStyle(
                              fontFamily: "SFProDisplay",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ))
                      ],
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: 20,
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.star,
                            size: 30,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Rate in App Store",
                              style: TextStyle(
                                fontFamily: "SFProDisplay",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ))
                        ],
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.square_arrow_left,
                      color: Colors.red,
                      size: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text("Sign Out",
                        style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.red)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/hex.svg",
                        height: 30,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Version ${_packageInfo.version} (${_packageInfo.buildNumber})",
                        style: TextStyle(color: Color(0xFF6F6F6F)),
                      ),
                      GestureDetector(
                        onTap: () {
                          TermsOfUse.show(context);
                        },
                        child: Text(
                          "Terms & Privacy",
                          style: TextStyle(color: Color(0xFF6F6F6F)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
