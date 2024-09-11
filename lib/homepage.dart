import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:cardnest/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardnest/models/loyalty_cards.dart';
import 'package:cardnest/card_modal.dart';
import 'package:cardnest/providers/card_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TextEditingController _searchController;
  List<LoyaltyCard> _filteredCards = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterCards);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCards() {
    final query = _searchController.text.toLowerCase();
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    setState(() {
      _filteredCards = cardProvider.cards.where((card) {
        return card.name.toLowerCase().contains(query);
      }).toList();
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
                AppLocalizations.of(context)!.card_title,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFProRounded',
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          icon: Icon(
                            CupertinoIcons.search,
                            color: Theme.of(context).cardColor,
                          ),
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: TextStyle(
                            fontFamily: 'SFProRounded',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).cardColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Consumer<CardProvider>(
                builder: (context, cardProvider, _) {
                  final cards = _filteredCards.isEmpty
                      ? cardProvider.cards
                      : _filteredCards;

                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: (cards.length / 2).ceil(), // Number of rows
                      itemBuilder: (BuildContext context, int index) {
                        final firstItemIndex = index * 2;
                        final secondItemIndex = firstItemIndex + 1;

                        Widget buildCard(LoyaltyCard card) {
                          final cardInfo =
                              CardStorage.getCardDetails(card.name);
                          final cardColor = cardInfo?['color'] ?? Colors.grey;
                          final cardLogo = cardInfo?['logo'];

                          return Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: MediaQuery.of(context).size.width *
                                0.44 /
                                1.586,
                            decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15,
                                    spreadRadius: -7,
                                    offset: Offset(0, 0),
                                  ),
                                ]),
                            child: Center(
                              child: cardLogo != null
                                  ? CachedNetworkImage(
                                      imageUrl: cardLogo,
                                      width: MediaQuery.of(context).size.width *
                                          0.37,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.09,
                                    )
                                  : Text(
                                      card.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: 'SFProRounded',
                                      ),
                                    ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  CardModal.show(
                                    context,
                                    cards[firstItemIndex].name,
                                    cards[firstItemIndex].barcode,
                                    cards[firstItemIndex].format,
                                  );
                                },
                                child: buildCard(cards[firstItemIndex]),
                              ),
                              if (secondItemIndex < cards.length)
                                GestureDetector(
                                  onTap: () {
                                    CardModal.show(
                                      context,
                                      cards[secondItemIndex].name,
                                      cards[secondItemIndex].barcode,
                                      cards[secondItemIndex].format,
                                    );
                                  },
                                  child: buildCard(cards[secondItemIndex]),
                                ),
                              if (secondItemIndex >= cards.length)
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.44,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
