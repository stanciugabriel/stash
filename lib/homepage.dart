import 'package:Stash/add_barcode.dart';
import 'package:Stash/delete_account_modal.dart';
import 'package:Stash/models/fidelity_card.dart';
import 'package:Stash/models/store.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:Stash/providers/stores_provider.dart';
import 'package:Stash/testpad.dart';
import 'package:Stash/utils/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Stash/card_modal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TextEditingController _searchController;
  List<FidelityCard> rawCards = [];
  List<Store> rawStores = [];
  List<FidelityCard> _filteredCards = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cards = Provider.of<FidelityCardsProvider>(context, listen: false);
      final stores = Provider.of<StoresProvider>(context, listen: false);

      rawCards = cards.cards;
      _filteredCards = rawCards;
      rawStores = stores.rawStores;
    });

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

    List<String> queryStores = [];
    for (int i = 0; i < rawStores.length; i++) {
      if (rawStores[i].name.toLowerCase().contains(query.toLowerCase())) {
        queryStores.add(rawStores[i].id);
      }
    }

    setState(() {
      if (query == '') {
        _filteredCards = rawCards;
      } else {
        _filteredCards = [];
        for (int i = 0; i < rawCards.length; i++) {
          if (queryStores.contains(rawCards[i].storeID)) {
            _filteredCards.add(rawCards[i]);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          Row(
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  DeleteAccountModal.show(context);
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddBarcode()),
                  );
                },
                onDoubleTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Testpad()));
                },
                child: Text(
                  AppLocalizations.of(context)!.card_title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFProRounded',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: AppLocalizations.of(context)!.search,
                          hintStyle: TextStyle(
                            fontFamily: 'SFProRounded',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
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
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Consumer<StoresProvider>(builder: (context, stores, _) {
                return Consumer<FidelityCardsProvider>(
                  builder: (context, cards, _) {
                    final showCards = _searchController.text == ''
                        ? cards.cards
                        : _filteredCards;

                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount:
                            (showCards.length / 2).ceil(), // Number of rows
                        itemBuilder: (BuildContext context, int index) {
                          final firstItemIndex = index * 2;
                          final secondItemIndex = firstItemIndex + 1;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      CardModal.show(
                                        context,
                                        showCards[firstItemIndex].id,
                                      );
                                    },
                                    child: cardBuilder(
                                      context,
                                      showCards[firstItemIndex],
                                      stores.stores,
                                    )),
                                if (secondItemIndex < showCards.length)
                                  GestureDetector(
                                      onTap: () {
                                        CardModal.show(
                                          context,
                                          showCards[secondItemIndex].id,
                                        );
                                      },
                                      child: cardBuilder(
                                        context,
                                        showCards[secondItemIndex],
                                        stores.stores,
                                      )),
                                if (secondItemIndex >= showCards.length)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
