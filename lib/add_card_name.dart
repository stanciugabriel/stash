import 'package:cardnest/cardlistpage.dart';
import 'package:cardnest/homepage.dart';
import 'package:cardnest/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cardnest/models/card.dart' as LoyalCard;

class AddCardName extends StatefulWidget {
  final String cardCode;
  final String codeType;
  const AddCardName(
      {required this.cardCode, required this.codeType, super.key});

  @override
  State<AddCardName> createState() => _AddCardNameState();
}

class _AddCardNameState extends State<AddCardName> {
  TextEditingController cardcontroller = TextEditingController();
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
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Enter the name of the store",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'SFProRounded',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Please enter the name of the store that issued the loyalty card.",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'SFProRounded',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.familyName],
                      controller: cardcontroller,
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
              String cardName = cardcontroller.text;
              if (cardName.isNotEmpty) {
                LoyalCard.Card newCard = LoyalCard.Card(
                    barcode: widget.cardCode,
                    name: cardName,
                    format: widget.codeType);

                List<LoyalCard.Card> cards =
                    await LoyalCard.CardStorage.getCards();
                cards.add(newCard);

                await LoyalCard.CardStorage.saveCards(cards);

                // Pass a success result back to the previous screen
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavBar(
                              pageIndex: 0,
                            )),
                  ); // true indicates that a new card was added
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
                    const SizedBox(
                      height: 30,
                      child: Text(
                        'Continua',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SFProRounded',
                        ),
                      ),
                    )
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
