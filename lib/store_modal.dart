import 'package:Stash/models/store.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:Stash/utils/url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Stash/providers/stores_provider.dart'; // Import the StoresProvider
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
  List<Store> filteredStores = [];
  List<Store> rawStores = [];
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
        filteredStores = stores.rawStores;
      });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStores);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStores() {
    setState(() {
      filteredStores = rawStores
          .where((store) => store.name
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
                    child: const Icon(CupertinoIcons.arrow_left)),
                const SizedBox(
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
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show a loading indicator
                : Consumer<AccountProvider>(builder: (context, auth, _) {
                    return Consumer<FidelityCardsProvider>(
                        builder: (context, cards, _) {
                      return Consumer<StoresProvider>(
                        builder: (context, stores, _) {
                          if (filteredStores.isEmpty &&
                              _searchController.text.isEmpty) {
                            // Initialize filteredStores with all stores on first load
                            filteredStores = stores.rawStores;
                          }

                          return ListView.builder(
                            itemCount: filteredStores.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await cards.addCardAttachStore(
                                      filteredStores[index].id);

                                  await cards.addFidelityCard(auth.token);
                                  if (mounted) Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5),
                                  child: Row(children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.17 /
                                              1.586,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: getStoreImage(
                                              filteredStores[index].id),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
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
    );
  }
}
