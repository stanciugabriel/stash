import 'dart:developer';

import 'package:cardnest/homepage.dart';
import 'package:cardnest/providers/stores_provider.dart';
import 'package:cardnest/rewards.dart';
import 'package:cardnest/scan_modal.dart';
import 'package:cardnest/settings.dart';
import 'package:cardnest/utils/gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final int pageIndex;
  const NavBar({
    required this.pageIndex,
    super.key,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final stores = Provider.of<StoresProvider>(context, listen: false);
      await stores.loadStores();
      await stores.fetchStores();
      inspect(stores.stores);
    });
    _selectedIndex = widget.pageIndex;
  }

  final List<Widget> _screens = [
    const Homepage(),
    const Rewards(),
    const Settings(),
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
                  color: Theme.of(context).disabledColor,
                  boxShadow: const [
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
                    const SizedBox(),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(0);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/home.svg",
                        height: 30,
                        color: _selectedIndex == 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(1);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/percent.svg",
                        height: 30,
                        color: _selectedIndex == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(2);
                      },
                      child: SvgPicture.asset(
                        "assets/icons/settings.svg",
                        height: 30,
                        color: _selectedIndex == 2
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScanModal.show(context);
                      },
                      child: const Icon(
                        CupertinoIcons.add_circled_solid,
                        color: Color.fromARGB(255, 24, 104, 242),
                        size: 30,
                      ),
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
