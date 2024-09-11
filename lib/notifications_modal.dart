import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsModal extends StatefulWidget {
  const NotificationsModal({super.key});

  @override
  State<NotificationsModal> createState() => _NotificationsModal();

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
          return const NotificationsModal();
        });
  }
}

class _NotificationsModal extends State<NotificationsModal> {
  bool switchValue = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(CupertinoIcons.chevron_back)),
              Text(
                AppLocalizations.of(context)!.notifications,
                style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
              ),
              Icon(
                CupertinoIcons.arrow_left,
                color: Colors.white.withOpacity(0),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.push_notifications,
                style: TextStyle(
                    fontFamily: "SFProDisplay",
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              CupertinoSwitch(
                value: switchValue,
                onChanged: (bool? value) {
                  setState(() {
                    switchValue = value ?? false;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
