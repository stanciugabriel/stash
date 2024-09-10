import 'package:cardnest/homepage.dart';
import 'package:cardnest/rewards.dart';
import 'package:cardnest/scan_modal.dart';
import 'package:cardnest/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';

class NavBar extends StatefulWidget {
  final int pageIndex;
  const NavBar({
    required this.pageIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  final List<Widget> _screens = [
    Homepage(),
    Rewards(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          _screens[_selectedIndex],
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: -7,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(0);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/home.svg",
                        height: 30,
                        color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(1);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/percent.svg",
                        height: 30,
                        color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(2);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/settings.svg",
                        height: 30,
                        color: _selectedIndex == 2 ? Colors.black : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScanModal.show(context);
                      },
                      child: Icon(
                        CupertinoIcons.add_circled_solid,
                        color: Color.fromARGB(255, 24, 104, 242),
                        size: 30,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
