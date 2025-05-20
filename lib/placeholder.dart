import 'package:Stash/scan_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardPlaceholder extends StatelessWidget {
  const CardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.blueAccent
                : const Color.fromARGB(255, 224, 236, 255),
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(15.0),
            child: Icon(
              CupertinoIcons.creditcard_fill,
              color: Colors.blueAccent,
              size: 35,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.addYourFirstCard,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'SFProRounded',
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            AppLocalizations.of(context)!.noCardsYet,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF6F6F6F),
              fontSize: 14,
              fontFamily: 'SFProRounded',
            ),
          ),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            ScanModal.show(context);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'New Card',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SFProRounded',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(CupertinoIcons.add, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
