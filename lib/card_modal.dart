import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:provider/provider.dart';
import 'package:cardnest/models/loyalty_cards.dart';
import 'package:cardnest/providers/card_provider.dart'; // Import the CardProvider
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardModal extends StatefulWidget {
  final String name;
  final String barcode;
  final String format; // Added format parameter

  const CardModal({
    super.key,
    required this.name,
    required this.barcode,
    required this.format, // Initialize format
  });

  @override
  State<CardModal> createState() => _CardModal();

  static void show(
      BuildContext context, String name, String barcode, String format) async {
    final brightness = await ScreenBrightness().current;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (BuildContext context) {
          return CardModal(name: name, barcode: barcode, format: format);
        }).then((_) async {
      // Restore the previous brightness level when the modal is dismissed
      await ScreenBrightness().setScreenBrightness(brightness);
    });
  }
}

class _CardModal extends State<CardModal> {
  // Define a mapping for barcode format to height
  final Map<String, double> barcodeHeights = {
    'BarcodeFormat.ean13': 120,
    'BarcodeFormat.code128': 120,
    'BarcodeFormat.code93': 110,
    'BarcodeFormat.dataMatrix': 150,
    'BarcodeFormat.aztec': 150,
    'BarcodeFormat.qrCode': 200,
    'BarcodeFormat.upca': 120,
    'BarcodeFormat.upce': 120,
    'BarcodeFormat.code39': 110,
    'BarcodeFormat.itf': 120,
    'BarcodeFormat.pdf417': 100,
  };

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ScreenBrightness().setScreenBrightness(1.0);
    });

    // Get the card details from the CardStorage class
    final cardInfo = CardStorage.getCardDetails(widget.name);
    final cardColor =
        cardInfo?['color'] ?? Colors.grey; // Default color if not found
    final cardLogo = cardInfo?['logo'];

    // Determine the barcode format based on the card's format property
    Barcode barcode;
    switch (widget.format) {
      case 'BarcodeFormat.ean13':
        barcode = Barcode.ean13();
        break;
      case 'BarcodeFormat.code128':
        barcode = Barcode.code128();
        break;
      case 'BarcodeFormat.code93':
        barcode = Barcode.code93();
        break;
      case 'BarcodeFormat.dataMatrix':
        barcode = Barcode.dataMatrix();
        break;
      case 'BarcodeFormat.aztec':
        barcode = Barcode.aztec();
        break;
      case 'BarcodeFormat.qrCode':
        barcode = Barcode.qrCode();
        break;
      case 'BarcodeFormat.upca':
        barcode = Barcode.upcA();
        break;
      case 'BarcodeFormat.upce':
        barcode = Barcode.upcE();
        break;
      case 'BarcodeFormat.code39':
        barcode = Barcode.code39();
        break;
      case 'BarcodeFormat.itf':
        barcode = Barcode.itf();
        break;
      case 'BarcodeFormat.pdf417':
        barcode = Barcode.pdf417();
        break;
      default:
        barcode = Barcode.qrCode(); // Default to QR code if unknown format
        break;
    }

    // Get the height for the barcode based on the format
    final barcodeHeight = barcodeHeights[widget.format] ?? 100.0;

    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor, // Use card color from map
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  spreadRadius: -7,
                  offset: Offset(0, 0),
                ),
              ],
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
                          color: getCloseButtonColor(cardColor),
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
                          ? CachedNetworkImage(
                              imageUrl: cardLogo,
                              height: MediaQuery.of(context).size.height * 0.1,
                            )
                          : Text(
                              widget.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                      const SizedBox(
                        height: 10,
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
                                height: barcodeHeight,
                                drawText: false,
                                data: widget.barcode,
                                barcode: barcode,
                              ),
                              const SizedBox(
                                height: 17,
                              ),
                              Text(
                                widget.barcode,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "SFProDisplay",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
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
                const Icon(
                  CupertinoIcons.pencil,
                  size: 35,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.edit,
                      style: const TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.3),
                    ),
                    Text(
                      AppLocalizations.of(context)!.edit_description,
                      style: const TextStyle(
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
                const Icon(
                  CupertinoIcons.share,
                  size: 35,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.share,
                        style: const TextStyle(
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.3),
                      ),
                      Text(
                        AppLocalizations.of(context)!.share_description,
                        style: const TextStyle(
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
              _deleteCard(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.delete_solid,
                    size: 35,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.delete,
                        style: const TextStyle(
                          fontFamily: "SFProDisplay",
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.3,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.delete_description,
                        style: const TextStyle(
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

  Future<void> _deleteCard(BuildContext context) async {
    print("Deleting card: ${widget.name}"); // Debug statement
    final cardProvider = Provider.of<CardProvider>(context, listen: false);

    // Create the card to delete
    final cardToDelete = LoyaltyCard(
      barcode: widget.barcode,
      name: widget.name,
      format: widget.format,
    );

    // Call removeCard and wait for completion
    await cardProvider.removeCard(cardToDelete);
    Navigator.pop(context); // Close the modal
  }
}

// Method to calculate if the color is light or dark
bool isLightColor(Color color) {
  return ThemeData.estimateBrightnessForColor(color) == Brightness.light;
}

// Method to get the close button color based on background
Color getCloseButtonColor(Color backgroundColor) {
  return isLightColor(backgroundColor) ? Colors.black : Colors.white;
}
