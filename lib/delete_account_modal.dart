import 'dart:developer';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAccountModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer<FidelityCardsProvider>(builder: (context, cards, _) {
            return Consumer<AccountProvider>(
              builder: (context, auth, _) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(9),
                        topRight: Radius.circular(9),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 255, 210, 207)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  CupertinoIcons.exclamationmark_triangle_fill,
                                  color: Colors.red,
                                  size: 35,
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 228, 228, 228)),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.close,
                                    color: Color.fromARGB(255, 170, 170, 170),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ), // Adjust as per your icon
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.are_you_sure,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                fontFamily: "SFProRounded",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!.delete_account_warning,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProRounded",
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!
                              .this_action_cannot_be_reverted,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFProRounded",
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            await auth.logout();
                            await cards.unloadCards();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.red),
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .delete_account,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "SFProRounded",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        });
  }
}
