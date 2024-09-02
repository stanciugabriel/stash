import 'package:cardnest/add_card_name.dart';
import 'package:cardnest/alert_box.dart';
import 'package:cardnest/card_preview.dart';
import 'package:cardnest/scan_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cardnest/models/card.dart' as LCard;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Color> pastelColors = [
    Color(0xFFF8BBD0), // Pink
    Color(0xFFC8E6C9), // Green
    Color(0xFFBBDEFB), // Blue
    Color(0xFFFFF9C4), // Yellow
    Color(0xFFD1C4E9), // Purple
  ];

  List<LCard.Card> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  // Load cards from local storage
  Future<void> _loadCards() async {
    List<LCard.Card> cards = await LCard.CardStorage.getCards();
    setState(() {
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 224, 224),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Text(
                            "Search...",
                            style: TextStyle(
                                fontFamily: 'SFProRounded',
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    ScanModal.show(context);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF6A992F), // Dark green
                          Color(0xFFB1FF4E), // Light green
                        ],
                        begin: Alignment.bottomLeft, // Start from the top-right
                        end: Alignment.topRight, // End at the bottom-left
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.add,
                            size: 20,
                            color: Color(0xFF213A00),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Add",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'SFProRounded'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25), // Add spacing between Row and ListView
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "Loyalty cards",
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFProRounded'),
              ),
            ],
          ),
          SizedBox(height: 5), // Add spacing between Row and ListView

          // Container(
          //   height: 70,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: 7,
          //     itemBuilder: (BuildContext context, int index) {
          //       if (index != 0) {
          //         return Row(
          //           children: [
          //             Container(
          //               width: 70, // Fixed width for each item
          //               decoration: BoxDecoration(
          //                   color: pastelColors[index % pastelColors.length],
          //                   shape: BoxShape.circle),
          //             ),
          //             SizedBox(
          //               width: 15,
          //             ),
          //           ],
          //         );
          //       } else {
          //         return SizedBox(
          //           width: 20,
          //         );
          //       }
          //     },
          //   ),
          // ),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  itemCount: (_cards.length / 2).ceil(), // Number of rows
                  itemBuilder: (BuildContext context, int index) {
                    final int firstItemIndex = index * 2;
                    final int secondItemIndex = firstItemIndex + 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // First item
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CardPreview(
                                        code: _cards[firstItemIndex].barcode,
                                        name: _cards[firstItemIndex].name,
                                        format: _cards[firstItemIndex].format)),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.44, // 44% of the screen width
                              height: MediaQuery.of(context).size.width *
                                  0.44 /
                                  1.586, // Credit card aspect ratio
                              decoration: BoxDecoration(
                                color: pastelColors[
                                    firstItemIndex % pastelColors.length],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                  child: Text(
                                _cards[firstItemIndex].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'SFProRounded'),
                              )),
                            ),
                          ),
                          // Second item (if it exists)
                          if (secondItemIndex < _cards.length)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CardPreview(
                                          code: _cards[secondItemIndex].barcode,
                                          name: _cards[secondItemIndex].name,
                                          format:
                                              _cards[secondItemIndex].format)),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    0.44, // 44% of the screen width
                                height: MediaQuery.of(context).size.width *
                                    0.44 /
                                    1.586, // Credit card aspect ratio
                                decoration: BoxDecoration(
                                  color: pastelColors[
                                      secondItemIndex % pastelColors.length],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                    child: Text(
                                  _cards[secondItemIndex].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'SFProRounded'),
                                )),
                              ),
                            ),
                          // Spacer if second item doesn't exist (for last odd row)
                          if (secondItemIndex >= _cards.length)
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.44),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
