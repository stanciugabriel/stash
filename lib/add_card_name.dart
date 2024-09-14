import 'dart:io';
import 'package:Stash/models/store.dart';
import 'package:Stash/navbar.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:Stash/providers/stores_provider.dart';
import 'package:Stash/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCardName extends StatefulWidget {
  final String barcode;
  final String format;

  const AddCardName({
    required this.barcode,
    required this.format,
    super.key,
  });

  @override
  State<AddCardName> createState() => _AddCardNameState();
}

class _AddCardNameState extends State<AddCardName> {
  final TextEditingController _searchController = TextEditingController();
  List<Store> filteredStores = [];
  List<Store> rawStores = []; // List to store all store names initially
  String selectedStoreID = '';
  bool isLoading = false; // To show loading state while stores load

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_filterStores);

    // Load stores from the provider
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cards = Provider.of<FidelityCardsProvider>(context, listen: false);
      final stores = Provider.of<StoresProvider>(context, listen: false);

      await cards.addCardAttachBarcode(widget.barcode, widget.format);
      setState(() {
        rawStores = stores.rawStores;
        // filteredStores = stores.rawStores;
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStores);
    _searchController.dispose();
    super.dispose();
  }

  // Filters the stores based on user input
  void _filterStores() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredStores = []; // Empty list if no characters are typed
      } else {
        filteredStores = rawStores
            .where((store) => store.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
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
                      controller: _searchController,
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
                    ? const Center(
                        child:
                            CircularProgressIndicator()) // Show a loading indicator
                    : Consumer<AccountProvider>(builder: (context, auth, _) {
                        return Consumer<FidelityCardsProvider>(
                            builder: (context, cards, _) {
                          return Consumer<StoresProvider>(
                            builder: (context, stores, _) {
                              return ListView.builder(
                                itemCount: filteredStores.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedStoreID =
                                            filteredStores[index].id;
                                      });
                                    },
                                    child: DecoratedBox(
                                      decoration: filteredStores[index].id ==
                                              selectedStoreID
                                          ? BoxDecoration(
                                              color: lightGrey,
                                              borderRadius:
                                                  BorderRadius.circular(12))
                                          : const BoxDecoration(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10),
                                        child: Row(children: [
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
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              // child: CachedNetworkImage(
                                              //   imageUrl: storesProvider.stores[index].logoUrl, // Ensure this property exists
                                              //   errorWidget: (context, url, error) =>
                                              //       Icon(Icons.error),
                                              // ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            filteredStores[index].name,
                                            style: const TextStyle(
                                                fontFamily: "SFProDisplay",
                                                fontSize: 16),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        });
                      }),
              ),

              // up to here
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          onTap: () async {
            final cards =
                Provider.of<FidelityCardsProvider>(context, listen: false);
            final auth = Provider.of<AccountProvider>(context, listen: false);

            await cards.addCardAttachStore(selectedStoreID);
            await cards.addFidelityCard(auth.token).then((_) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NavBar(pageIndex: 0)));
            });
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
                        style: const TextStyle(
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
