import 'package:Stash/appearance_modal.dart';
import 'package:Stash/language_modal.dart';
import 'package:Stash/notifications_modal.dart';
import 'package:Stash/onboarding/onboarding_phone.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:Stash/terms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
    return Consumer<FidelityCardsProvider>(builder: (context, cards, _) {
      return Consumer<AccountProvider>(builder: (context, auth, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  auth.token != ''
                      ? Row(
                          children: [
                            SvgPicture.asset("assets/icons/profile.svg"),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${auth.account.firstName} ${auth.account.lastName}',
                                  style: const TextStyle(
                                      fontFamily: "SFProDisplay",
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .account_settings,
                                      style: const TextStyle(
                                          fontFamily: "SFProDisplay",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF6F6F6F)),
                                    ),
                                    const Icon(
                                      CupertinoIcons.forward,
                                      color: Color(0xFF6F6F6F),
                                      size: 16,
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const OnboardingPhone()));
                          },
                          child: Row(
                            children: [
                              // SvgPicture.asset("assets/icons/profile.svg"),
                              // const SizedBox(
                              //   width: 15,
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .create_account,
                                    style: const TextStyle(
                                        fontFamily: "SFProDisplay",
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .stash_is_better_with_an_account,
                                        style: const TextStyle(
                                            fontFamily: "SFProDisplay",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF6F6F6F)),
                                      ),
                                      const Icon(
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
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(AppLocalizations.of(context)!.preferences,
                      style: const TextStyle(
                        fontFamily: "SFProDisplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6F6F6F),
                      )),
                  const SizedBox(
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
                              const Icon(
                                CupertinoIcons.bell,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(AppLocalizations.of(context)!.notifications,
                                  style: const TextStyle(
                                    fontFamily: "SFProDisplay",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ))
                            ],
                          ),
                          const Icon(
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
                              const Icon(
                                CupertinoIcons.paintbrush,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(AppLocalizations.of(context)!.appearance,
                                  style: const TextStyle(
                                    fontFamily: "SFProDisplay",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ))
                            ],
                          ),
                          const Icon(
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
                        LanguageModal.show(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.globe,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(AppLocalizations.of(context)!.language,
                                  style: const TextStyle(
                                    fontFamily: "SFProDisplay",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ))
                            ],
                          ),
                          const Icon(
                            CupertinoIcons.chevron_right,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(AppLocalizations.of(context)!.resources,
                      style: const TextStyle(
                        fontFamily: "SFProDisplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6F6F6F),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.ellipses_bubble,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(AppLocalizations.of(context)!.leave_feedback,
                                style: const TextStyle(
                                  fontFamily: "SFProDisplay",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ))
                          ],
                        ),
                        const Icon(
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
                              const Icon(
                                CupertinoIcons.star,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                  AppLocalizations.of(context)!
                                      .rate_in_app_store,
                                  style: const TextStyle(
                                    fontFamily: "SFProDisplay",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ))
                            ],
                          ),
                          const Icon(
                            CupertinoIcons.chevron_right,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (auth.token != '')
                    GestureDetector(
                      onTap: () async {
                        await auth.logout();
                        await cards.unloadCards();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.square_arrow_left,
                              color: Colors.red,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(AppLocalizations.of(context)!.sign_out,
                                style: const TextStyle(
                                    fontFamily: "SFProDisplay",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red)),
                          ],
                        ),
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
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.version} ${_packageInfo.version} (${_packageInfo.buildNumber})",
                            style: const TextStyle(color: Color(0xFF6F6F6F)),
                          ),
                          GestureDetector(
                            onTap: () {
                              TermsOfUse.show(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.terms_and_privacy,
                              style: const TextStyle(color: Color(0xFF6F6F6F)),
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
      });
    });
  }
}
