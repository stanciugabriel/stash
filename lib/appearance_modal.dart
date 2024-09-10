import 'package:cardnest/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        return const AppearanceModal();
      },
    );
  }
}

class _AppearanceModal extends State<AppearanceModal> {
  String selectedScheme = 'System';

  @override
  void initState() {
    super.initState();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    selectedScheme = themeProvider.selectedScheme;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                  child: Icon(CupertinoIcons.chevron_back)),
              Text(
                "Appearance",
                style: TextStyle(
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
          SizedBox(height: 20),
          Text(
            "Color Scheme",
            style: TextStyle(
              fontFamily: "SFProDisplay",
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Text(
            "Turn on dark mode, or let CardNest visually match your device settings.",
            style: TextStyle(
              fontFamily: "SFProDisplay",
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedScheme = 'System';
                    });
                    themeProvider.setSystemTheme();
                  },
                  child: ThemeSwitcher(
                    isSelected: selectedScheme == 'System',
                    label: 'System',
                    icon: CupertinoIcons.circle_lefthalf_fill,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedScheme = 'Light';
                    });
                    themeProvider.setLightTheme();
                  },
                  child: ThemeSwitcher(
                    isSelected: selectedScheme == 'Light',
                    label: 'Light',
                    icon: CupertinoIcons.sun_max_fill,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedScheme = 'Dark';
                    });
                    themeProvider.setDarkTheme();
                  },
                  child: ThemeSwitcher(
                    isSelected: selectedScheme == 'Dark',
                    label: 'Dark',
                    icon: CupertinoIcons.moon_fill,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ThemeSwitcher extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;

  const ThemeSwitcher({
    Key? key,
    required this.isSelected,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: isSelected ? Colors.blue : Colors.grey,
        end: isSelected ? Colors.blue : Colors.grey,
      ),
      duration: Duration(milliseconds: 300),
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
                  duration: Duration(milliseconds: 300),
                  builder: (context, iconColor, child) {
                    return Icon(icon, color: iconColor);
                  },
                ),
                SizedBox(height: 20),
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: isSelected ? Colors.blue : Colors.grey,
                    end: isSelected ? Colors.blue : Colors.grey,
                  ),
                  duration: Duration(milliseconds: 300),
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
