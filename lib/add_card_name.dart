import 'package:cardnest/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardnest/models/loyalty_cards.dart'; // New LoyaltyCard class
import 'package:cardnest/providers/card_provider.dart'; // Provider for managing cards
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
              const SizedBox(height: 15),
              Text(
                AppLocalizations.of(context)!.card_name_title,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'SFProRounded',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.card_name_description,
                style: TextStyle(
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
                        fillColor: const Color(0xFFE8E8E8),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: const Color(0XFF2E01C8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.continue_button,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProRounded',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
