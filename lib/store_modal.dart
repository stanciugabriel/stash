import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:provider/provider.dart';
import 'package:Stash/models/loyalty_cards.dart';
import 'package:Stash/providers/card_provider.dart'; // Import the CardProvider
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StoreModal extends StatefulWidget {
  final String barcode;
  final String format; // Added format parameter

  const StoreModal({
    super.key,
    required this.barcode,
    required this.format, // Initialize format
  });

  @override
  State<StoreModal> createState() => _StoreModal();

  static void show(BuildContext context, String barcode, String format) async {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).primaryColorDark,
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (BuildContext context) {
          return StoreModal(barcode: barcode, format: format);
        });
  }
}

class _StoreModal extends State<StoreModal> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> stores = [
    'Catena',
    'Kaufland',
    'OptiBlu',
  ];

  List<String> filteredStores = [];

  @override
  void initState() {
    super.initState();
    filteredStores = stores;
    _searchController.addListener(_filterStores);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStores);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStores() {
    setState(() {
      filteredStores = stores
          .where((store) => store
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(CupertinoIcons.arrow_left)),
                SizedBox(
                  width: 15,
                ),
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredStores.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    String cardName = filteredStores[index];
                    LoyaltyCard newCard = LoyaltyCard(
                      barcode: widget.barcode,
                      name: cardName,
                      format: widget.format,
                    );

                    Provider.of<CardProvider>(context, listen: false)
                        .addCard(newCard);
                    if (mounted) Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Row(children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.17,
                        height:
                            MediaQuery.of(context).size.width * 0.17 / 1.586,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey[100],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Kaufland_201x_logo.svg/1200px-Kaufland_201x_logo.svg.png',
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        filteredStores[index],
                        style:
                            TextStyle(fontFamily: "SFProDisplay", fontSize: 16),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
