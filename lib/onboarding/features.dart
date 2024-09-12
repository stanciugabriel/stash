import 'package:cardnest/alert_box.dart';
import 'package:cardnest/homepage.dart';
import 'package:cardnest/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cardnest/onboarding/account_prompt.dart'; // Import AccountPrompt
import 'background_widget.dart'; // Import the background widget
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Features extends StatefulWidget {
  const Features({super.key});

  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  List<bool> _visible = [
    false,
    false,
    false,
    false
  ]; // Control visibility of each feature

  @override
  void initState() {
    super.initState();
    _animateFeatures();
  }

  // This function will sequentially trigger the fade-in animation for each feature
  void _animateFeatures() async {
    for (int i = 0; i < _visible.length; i++) {
      await Future.delayed(
          Duration(milliseconds: 300)); // Delay between each feature
      setState(() {
        _visible[i] = true; // Make the feature visible
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 45),
          Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: Text(
                AppLocalizations.of(context)!
                    .meet_your_new_favourite_loyalty_app,
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1,
                  fontFamily: "SFProDisplay",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 3, 68, 230),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          // Wrap each feature in AnimatedOpacity with visibility control
          AnimatedOpacity(
            opacity: _visible[0] ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: FeatureContainer(
              context,
              icon: CupertinoIcons.lock_fill,
              iconColor: Colors.blue,
              title: AppLocalizations.of(context)!.store_your_loyalty_cards,
              description:
                  AppLocalizations.of(context)!.keep_all_cards_securely_stored,
            ),
          ),
          SizedBox(height: 10),
          AnimatedOpacity(
            opacity: _visible[1] ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: FeatureContainer(
              context,
              icon: CupertinoIcons.arrowshape_turn_up_right_fill,
              iconColor: Color(0xFFFE7C02),
              title: AppLocalizations.of(context)!.share_your_cards_with_ease,
              description:
                  AppLocalizations.of(context)!.share_cards_with_just_a_link,
            ),
          ),
          SizedBox(height: 10),
          AnimatedOpacity(
            opacity: _visible[2] ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: FeatureContainer(
              context,
              icon: CupertinoIcons.cloud_download_fill,
              iconColor: Color.fromARGB(255, 144, 144, 144),
              title: AppLocalizations.of(context)!.offline_access,
              description: AppLocalizations.of(context)!
                  .access_cards_without_an_internet_connection,
            ),
          ),
          SizedBox(height: 10),
          AnimatedOpacity(
            opacity: _visible[3] ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: FeatureContainer(
              context,
              icon: CupertinoIcons.arrow_up_circle_fill,
              iconColor: Color(0xFFFF6565),
              title: AppLocalizations.of(context)!.automatic_backup,
              description: AppLocalizations.of(context)!
                  .backup_cards_and_never_lose_them,
            ),
          ),
          Expanded(child: SizedBox()),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        AppLocalizations.of(context)!.create_an_account,
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
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              AlertBox.show(
                context, // Pass context here
                title: AppLocalizations.of(context)!
                    .stash_is_better_with_an_account,
                content: AppLocalizations.of(context)!.consider_acc,
                accept: AppLocalizations.of(context)!.create_account,
                decline: AppLocalizations.of(context)!.continue_without,
                acceptColor: Colors.white,
                acceptCallback: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountPrompt()), //Needs replacing
                ),
                declineCallback: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavBar(
                              pageIndex: 0,
                            )),
                  );
                },
              );
            },
            child: Text(
              AppLocalizations.of(context)!.continue_without_an_account,
              style: TextStyle(
                fontFamily: "SFProDisplay",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 3, 68, 230),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FeatureContainer(BuildContext context,
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String description}) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor,
              ),
              height: 35,
              width: 35,
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.4,
                    fontFamily: "SFProDisplay",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000630),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000630),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
