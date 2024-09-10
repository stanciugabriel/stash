import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:cardnest/models/card.dart' as LCard;

class CardModal extends StatefulWidget {
  final String name;
  final String barcode;

  const CardModal({Key? key, required this.name, required this.barcode})
      : super(key: key);

  @override
  State<CardModal> createState() => _CardModal();

  static void show(BuildContext context, String name, String barcode) {
    ScreenBrightness().current.then((brightness) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          builder: (BuildContext context) {
            return CardModal(name: name, barcode: barcode);
          }).then((_) async {
        // Restore the previous brightness level when the modal is dismissed
        await ScreenBrightness().setScreenBrightness(brightness);
      });
    });
  }
}

class _CardModal extends State<CardModal> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ScreenBrightness().setScreenBrightness(1.0);
    });

    // Get the card details from the CardStorage class
    final cardInfo = LCard.CardStorage.getCardDetails(widget.name);
    final cardColor =
        cardInfo?['color'] ?? Colors.grey; // Default color if not found
    final cardLogo = cardInfo?['logo'];

    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor, // Use card color from map
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          CupertinoIcons.clear_thick_circled,
                          color: Colors.black,
                          size: 35,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 40, right: 30, left: 30),
                  child: Column(
                    children: [
                      // Display the logo or the card name
                      cardLogo != null
                          ? SvgPicture.asset(
                              cardLogo,
                              height: 30,
                            )
                          : Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30, right: 30, left: 30, bottom: 20),
                          child: Column(
                            children: [
                              BarcodeWidget(
                                height: 100,
                                drawText: false,
                                data: widget.barcode,
                                barcode: Barcode.code128(),
                              ),
                              SizedBox(
                                height: 17,
                              ),
                              Text(
                                widget.barcode,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "SFProDisplay",
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.pencil,
                  size: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit",
                      style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.3),
                    ),
                    Text(
                      "Edit your card details.",
                      style: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.share,
                  size: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Share",
                        style: TextStyle(
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.3),
                      ),
                      Text(
                        "Share this card with your friends.",
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              deleteCard(widget.barcode, context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.delete_solid,
                    size: 35,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.3,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Permanently delete this card.",
                        style: TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> deleteCard(String barcode, context) async {
  // Fetch the existing cards
  List<LCard.Card> cards = await LCard.CardStorage.getCards();

  // Find the card to delete and remove it
  cards.removeWhere((card) => card.barcode == barcode);

  // Save the updated list
  await LCard.CardStorage.saveCards(cards);

  // Close the modal
  Navigator.pop(context);
}
