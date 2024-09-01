import 'package:cardnest/add_card_name.dart';
import 'package:cardnest/scan_modal.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  // ScanModal.show(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCardName(
                              cardCode: "75o83205",
                              codeType: "BarcodeFormat.code128",
                            )),
                  );
                },
                child: Text(
                  "Start",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
