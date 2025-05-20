import 'package:Stash/models/fidelity_card.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:Stash/utils/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditModal extends StatefulWidget {
  final String id;

  const EditModal({super.key, required this.id});

  @override
  State<EditModal> createState() => _EditModal();

  static void show(BuildContext context, String id) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 244, 244, 244),
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
        FlutterStatusbarcolor.setStatusBarColor(Theme.of(context).dividerColor);
        return EditModal(id: id);
      },
    ).then((_) {
      FlutterStatusbarcolor.setStatusBarColor(
          Theme.of(context).primaryColorDark);
    });
  }
}

class _EditModal extends State<EditModal> {
  late TextEditingController nicknameController;
  late TextEditingController barcodeController;
  late FidelityCard currentCard;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final cards = Provider.of<FidelityCardsProvider>(context, listen: false);
    currentCard = cards.cards.firstWhere(
      (card) => card.id == widget.id,
      orElse: () => FidelityCard.fromEmpty(),
    );

    nicknameController = TextEditingController(text: currentCard.nickname);
    barcodeController = TextEditingController(text: currentCard.code);
  }

  @override
  void dispose() {
    nicknameController.dispose();
    barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FidelityCardsProvider, AccountProvider>(
      builder: (context, cards, auth, _) {
        return Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height * 0.92,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).shadowColor,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(
                              CupertinoIcons.creditcard_fill,
                              size: 30,
                              color: darkGrey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context)!.edit_your_card_details,
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'SFProRounded',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!
                              .you_can_change_both_name_and_id,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFProRounded',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 5),
                          child: TextField(
                            controller: nicknameController,
                            textInputAction: TextInputAction.done,
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
                              hintText: AppLocalizations.of(context)!.nickname,
                              hintStyle: const TextStyle(
                                  fontSize: 18, fontFamily: 'UberMoveMedium'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 5),
                          child: TextField(
                            controller: barcodeController,
                            enabled: false,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Theme.of(context).shadowColor,
                              filled: true,
                              hintText: AppLocalizations.of(context)!.barcode,
                              hintStyle: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'UberMoveMedium',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: GestureDetector(
                      onTap: () async {
                        if (_isLoading) return;

                        setState(() => _isLoading = true);

                        final newNickname = nicknameController.text.trim();
                        if (newNickname != currentCard.nickname) {
                          cards.updateCardSet(currentCard.id, newNickname);
                          await cards.updateFidelityCard(auth.token);
                        }

                        setState(() => _isLoading = false);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: blitzPurple,
                        ),
                        padding: const EdgeInsets.all(13.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!
                                        .continue_button,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFProRounded',
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
