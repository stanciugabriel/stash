import 'package:Stash/providers/locale_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageModal extends StatefulWidget {
  const LanguageModal({super.key});

  @override
  State<LanguageModal> createState() => _LanguageModal();

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
        return const LanguageModal();
      },
    );
  }
}

class _LanguageModal extends State<LanguageModal> {
  String selectedLanguage = 'System';

  final languages = [
    {'label': 'System', 'locale': null}, // System locale
    {'label': 'English', 'locale': const Locale('en')},
    {'label': 'Română', 'locale': const Locale('ro')},
  ];

  @override
  void initState() {
    super.initState();
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    final currentLocale = localeProvider.locale;
    selectedLanguage = currentLocale?.languageCode ?? 'System';
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(CupertinoIcons.chevron_back),
              ),
              Text(
                AppLocalizations.of(context)!.language,
                style: const TextStyle(
                  fontFamily: "SFProDisplay",
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              Icon(
                CupertinoIcons.arrow_left,
                color: Colors.white.withOpacity(0),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.language_title,
            style: const TextStyle(
              fontFamily: "SFProDisplay",
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.language_description,
            style: const TextStyle(
              fontFamily: "SFProDisplay",
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          ...languages.map((lang) {
            // Extract locale safely
            Locale? locale = lang['locale'] as Locale?;
            String flagEmoji;
            switch (locale?.languageCode) {
              case 'en':
                flagEmoji = '🇺🇸';
                break;
              case 'ro':
                flagEmoji = '🇷🇴';
                break;
              default:
                flagEmoji = '🌐';
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedLanguage = locale?.languageCode ?? 'System';
                });

                if (locale == null) {
                  localeProvider.setLocale(''); // Use system locale
                } else {
                  localeProvider.setLocale(locale.languageCode);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Spacing between rows
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          flagEmoji, // Display the flag
                          style: const TextStyle(
                            fontSize: 30, // Size of the flag emoji
                          ),
                        ),
                        const SizedBox(
                            width: 12), // Space between flag and label
                        Text(
                          lang['label'] as String, // Language name
                          style: const TextStyle(
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation, // Scale animation effect
                          child: child,
                        );
                      },
                      child:
                          selectedLanguage == (locale?.languageCode ?? 'System')
                              ? Icon(
                                  CupertinoIcons.checkmark_alt_circle_fill,
                                  color: Colors
                                      .blue, // Color for the selected checkmark
                                  size: 24, // Size of the checkmark icon
                                  key: ValueKey(
                                      selectedLanguage), // Unique key for AnimatedSwitcher
                                )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
