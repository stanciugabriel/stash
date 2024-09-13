import 'dart:io';
import 'package:Stash/providers/stores_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Stash/models/loyalty_cards.dart'; // New LoyaltyCard class
import 'package:Stash/providers/card_provider.dart'; // Provider for managing cards
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCardName extends StatefulWidget {
  final String cardCode;
  final String format;

  const AddCardName({
    required this.cardCode,
    required this.format,
    super.key,
  });

  @override
  State<AddCardName> createState() => _AddCardNameState();
}

class _AddCardNameState extends State<AddCardName> {
  TextEditingController cardController = TextEditingController();
  List<String> filteredStores = [];
  List<String> storeNames = []; // List to store all store names initially
  bool isLoading = true; // To show loading state while stores load

  @override
  void initState() {
    super.initState();

    cardController.addListener(_filterStores);

    // Load stores from the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storesProvider =
          Provider.of<StoresProvider>(context, listen: false);
      storesProvider.fetchStores().then((_) {
        setState(() {
          storeNames =
              storesProvider.rawStores.map((store) => store.name).toList();
          isLoading = false; // Turn off loading state
        });
      });
    });
  }

  @override
  void dispose() {
    cardController.removeListener(_filterStores);
    cardController.dispose();
    super.dispose();
  }

  // Filters the stores based on user input
  void _filterStores() {
    setState(() {
      if (cardController.text.isEmpty) {
        filteredStores = []; // Empty list if no characters are typed
      } else {
        filteredStores = storeNames
            .where((store) =>
                store.toLowerCase().contains(cardController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).shadowColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Icon(
                    CupertinoIcons.textformat_abc_dottedunderline,
                    size: 30,
                    color: Color.fromARGB(255, 76, 76, 76),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                AppLocalizations.of(context)!.card_name_title,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'SFProRounded',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.card_name_description,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'SFProRounded',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.name,
                      controller: cardController,
                      textInputAction: TextInputAction.done,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'UberMoveMedium',
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Theme.of(context).shadowColor,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show a loading indicator
                    : Consumer<StoresProvider>(
                        builder: (context, storesProvider, _) {
                          return filteredStores.isEmpty &&
                                  cardController.text.isEmpty
                              ? Container() // Show nothing if the search is empty
                              : ListView.builder(
                                  itemCount: filteredStores.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        String cardName = filteredStores[index];
                                        LoyaltyCard newCard = LoyaltyCard(
                                          barcode: widget.cardCode,
                                          name: cardName,
                                          format: widget.format,
                                        );

                                        Provider.of<CardProvider>(context,
                                                listen: false)
                                            .addCard(newCard);
                                        if (mounted) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.17,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.17 /
                                                  1.586,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.blueGrey[100],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                // Add CachedNetworkImage or placeholder if needed
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              filteredStores[index],
                                              style: TextStyle(
                                                fontFamily: "SFProDisplay",
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          onTap: () async {
            String cardName = cardController.text;
            if (cardName.isNotEmpty) {
              // Create a new LoyaltyCard instance
              LoyaltyCard newCard = LoyaltyCard(
                barcode: widget.cardCode,
                name: cardName,
                format: widget.format,
              );

              // Add the card to the provider
              Provider.of<CardProvider>(context, listen: false)
                  .addCard(newCard);

              // Pop the navigation twice to return to the homepage
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Padding(
              padding: EdgeInsets.only(bottom: Platform.isAndroid ? 15 : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 68, 230),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.continue_button,
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
