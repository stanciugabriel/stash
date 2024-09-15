import 'dart:ui';

import 'package:Stash/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppearanceModal extends StatefulWidget {
  const AppearanceModal({super.key});

  @override
  State<AppearanceModal> createState() => _AppearanceModal();

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
        FlutterStatusbarcolor.setStatusBarColor(Theme.of(context).dividerColor,
            animate: true);
        if (Theme.of(context).brightness == Brightness.dark) {
          FlutterStatusbarcolor.setNavigationBarColor(
              Theme.of(context).shadowColor,
              animate: true);
        }
        if (Theme.of(context).brightness == Brightness.light) {
          FlutterStatusbarcolor.setNavigationBarColor(
              Theme.of(context).primaryColorDark,
              animate: true);
        }
        return const AppearanceModal();
      },
    ).whenComplete(() {
      FlutterStatusbarcolor.setStatusBarColor(
          Theme.of(context).primaryColorDark,
          animate: true);
      FlutterStatusbarcolor.setNavigationBarColor(
          Theme.of(context).primaryColorDark);
    });
  }
}

class _AppearanceModal extends State<AppearanceModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<ThemeProvider>(builder: (context, theme, _) {
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
                    child: const Icon(CupertinoIcons.chevron_back)),
                Text(
                  AppLocalizations.of(context)!.appearance,
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
              AppLocalizations.of(context)!.color_scheme,
              style: const TextStyle(
                fontFamily: "SFProDisplay",
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.color_scheme_description,
              style: const TextStyle(
                fontFamily: "SFProDisplay",
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        theme.selectedScheme = 'System';
                      });

                      await themeProvider.setSystemTheme();

                      // if (Theme.of(context).brightness == Brightness.dark) {
                      //   FlutterStatusbarcolor.setNavigationBarColor(
                      //       Theme.of(context).shadowColor,
                      //       animate: true);
                      // }
                    },
                    child: ThemeSwitcher(
                      isSelected: theme.selectedScheme == 'System',
                      label: AppLocalizations.of(context)!.system_mode,
                      icon: CupertinoIcons.circle_lefthalf_fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        theme.selectedScheme = 'Light';
                      });

                      await themeProvider.setLightTheme();
                      // FlutterStatusbarcolor.setNavigationBarColor(
                      //   Theme.of(context).primaryColorDark,
                      //   animate: true,
                      // );
                    },
                    child: ThemeSwitcher(
                      isSelected: theme.selectedScheme == 'Light',
                      label: AppLocalizations.of(context)!.light_mode,
                      icon: CupertinoIcons.sun_max_fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        theme.selectedScheme = 'Dark';
                      });

                      await themeProvider.setDarkTheme();

                      // FlutterStatusbarcolor.setNavigationBarColor(
                      //     Theme.of(context).shadowColor,
                      //     animate: true);
                    },
                    child: ThemeSwitcher(
                      isSelected: theme.selectedScheme == 'Dark',
                      label: AppLocalizations.of(context)!.dark_mode,
                      icon: CupertinoIcons.moon_fill,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class ThemeSwitcher extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;

  const ThemeSwitcher({
    super.key,
    required this.isSelected,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: isSelected ? Colors.blue : Colors.grey,
        end: isSelected ? Colors.blue : Colors.grey,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, borderColor, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor!),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: isSelected ? Colors.blue : Colors.grey,
                    end: isSelected ? Colors.blue : Colors.grey,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, iconColor, child) {
                    return Icon(icon, color: iconColor);
                  },
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: isSelected ? Colors.blue : Colors.grey,
                    end: isSelected ? Colors.blue : Colors.grey,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, textColor, child) {
                    return Text(
                      label,
                      style: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
