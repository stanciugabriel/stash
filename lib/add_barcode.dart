import 'package:Stash/add_card_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' show Platform;

class AddBarcode extends StatefulWidget {
  const AddBarcode({
    super.key,
  });

  @override
  State<AddBarcode> createState() => _AddBarcodeState();
}

class _AddBarcodeState extends State<AddBarcode> {
  TextEditingController cardController = TextEditingController();
  String selectedBarcode = 'BarcodeFormat.code128';

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
                    CupertinoIcons.barcode,
                    size: 30,
                    color: Color.fromARGB(255, 76, 76, 76),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                AppLocalizations.of(context)!.enter_the_barcode,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'SFProRounded',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                AppLocalizations.of(context)!.enter_the_barcode_description,
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
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.how_does_your_barcode_look,
                style: const TextStyle(
                  fontFamily: "SFProDisplay",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBarcode = 'BarcodeFormat.code128';
                        });
                      },
                      child: BarcodeSwitcher(
                        isSelected: selectedBarcode == 'BarcodeFormat.code128',
                        label: "Code 128",
                        icon: CupertinoIcons.barcode,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBarcode = 'BarcodeFormat.qrCode';
                        });
                      },
                      child: BarcodeSwitcher(
                        isSelected: selectedBarcode == 'BarcodeFormat.qrCode',
                        label: "QR Code",
                        icon: CupertinoIcons.qrcode,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (cardController.text.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCardName(
                        barcode: cardController.text, format: selectedBarcode)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
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

class BarcodeSwitcher extends StatelessWidget {
  final bool isSelected;
  final String label;
  final IconData icon;

  const BarcodeSwitcher({
    super.key,
    required this.isSelected,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: isSelected ? Colors.blue : Colors.grey,
        end: isSelected ? Colors.blue : Colors.grey,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, borderColor, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor!),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: isSelected ? Colors.blue : Colors.grey,
                    end: isSelected ? Colors.blue : Colors.grey,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, iconColor, child) {
                    return Icon(icon, color: iconColor);
                  },
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(
                    begin: isSelected ? Colors.blue : Colors.grey,
                    end: isSelected ? Colors.blue : Colors.grey,
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, textColor, child) {
                    return Text(
                      label,
                      style: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: textColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
