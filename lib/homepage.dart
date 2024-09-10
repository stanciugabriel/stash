import 'package:cardnest/add_card_name.dart';
import 'package:cardnest/alert_box.dart';
import 'package:cardnest/card_modal.dart';
import 'package:cardnest/card_preview.dart';
import 'package:cardnest/rewards.dart';
import 'package:cardnest/scan_modal.dart';
import 'package:cardnest/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cardnest/models/card.dart' as LCard;
import 'package:flutter_svg/svg.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Color> pastelColors = [
    Color(0xFFCD1515), // Pink
    Color(0xFFC8E6C9), // Green
    Color(0xFFBBDEFB), // Blue
    Color(0xFFFFF9C4), // Yellow
    Color(0xFFD1C4E9), // Purple
  ];

  // Define card details with name, color, and logo
  final Map<String, Map<String, dynamic>> cardDetails = {
    'Penny': {'color': Colors.red, 'logo': 'assets/penny.svg'},
    'DrMax': {'color': Colors.green, 'logo': 'assets/icons/home.svg'},
    // Add other card names with their colors and logos
  };

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
          SizedBox(height: 70),
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                "Cards",
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFProRounded'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 224, 224, 224),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.search,
                            color: Color(0xFF4E4E4E),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Search...",
                            style: TextStyle(
                              fontFamily: 'SFProRounded',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF4E4E4E),
                            ),
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

                    Widget buildCard(LCard.Card card) {
                      final cardInfo = cardDetails[card.name];
                      final cardColor = cardInfo?['color'] ??
                          pastelColors[
                              card.name.hashCode % pastelColors.length];
                      final cardLogo = cardInfo?['logo'];

                      return Container(
                        width: MediaQuery.of(context).size.width *
                            0.44, // 44% of the screen width
                        height: MediaQuery.of(context).size.width *
                            0.44 /
                            1.586, // Credit card aspect ratio
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: cardLogo != null
                              ? SvgPicture.asset(cardLogo, height: 20)
                              : Text(
                                  card.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontFamily: 'SFProRounded'),
                                ),
                        ),
                      );
                    }

                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // First item
                            GestureDetector(
                              onTap: () {
                                CardModal.show(
                                  context,
                                  _cards[firstItemIndex].name,
                                  _cards[firstItemIndex].barcode,
                                );
                              },
                              child: buildCard(_cards[firstItemIndex]),
                            ),
                            // Second item (if it exists)
                            if (secondItemIndex < _cards.length)
                              GestureDetector(
                                onTap: () {
                                  CardModal.show(
                                    context,
                                    _cards[secondItemIndex].name,
                                    _cards[secondItemIndex].barcode,
                                  );
                                },
                                child: buildCard(_cards[secondItemIndex]),
                              ),
                            // Spacer if second item doesn't exist (for last odd row)
                            if (secondItemIndex >= _cards.length)
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44),
                          ],
                        ));
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
