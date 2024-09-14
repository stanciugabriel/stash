import 'package:Stash/delete_account_modal.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/locale_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountDetailsModal extends StatefulWidget {
  const AccountDetailsModal({super.key});

  @override
  State<AccountDetailsModal> createState() => _AccountDetailsModal();

  static void show(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9),
          topRight: Radius.circular(9),
        ),
      ),
      builder: (BuildContext context) {
        return const AccountDetailsModal();
      },
    );
  }
}

class _AccountDetailsModal extends State<AccountDetailsModal> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
      return Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height * 0.92,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(CupertinoIcons.chevron_back),
                ),
                Text(
                  AppLocalizations.of(context)!.account_details,
                  style: const TextStyle(
                    fontFamily: "SFProDisplay",
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.white.withOpacity(0),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.basic_info,
              style: TextStyle(
                fontFamily: "SFProDisplay",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 180, 180, 180),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  CupertinoIcons.person,
                  color: const Color.fromARGB(255, 180, 180, 180),
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.name_details,
                  style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Expanded(child: SizedBox()),
                Text(
                  '${auth.account.firstName} ${auth.account.lastName}',
                  style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 110, 110, 110)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  CupertinoIcons.phone,
                  size: 30,
                  color: const Color.fromARGB(255, 180, 180, 180),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.phone_number,
                  style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Expanded(child: SizedBox()),
                Text(
                  '${auth.account.phone.substring(0, 3)} ${auth.account.phone.substring(3, 6)} ${auth.account.phone.substring(6, 9)} ${auth.account.phone.substring(9)}',
                  style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 110, 110, 110),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => DeleteAccountModal.show(context),
              child: Row(
                children: [
                  Icon(CupertinoIcons.person_badge_minus,
                      size: 30, color: Colors.red),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.delete_account,
                    style: TextStyle(
                        fontFamily: "SFProDisplay",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
