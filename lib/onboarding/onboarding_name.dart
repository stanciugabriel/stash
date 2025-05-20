import 'dart:async';

import 'package:Stash/navbar.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:Stash/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingName extends StatefulWidget {
  const OnboardingName({super.key});

  @override
  State<OnboardingName> createState() => _OnboardingNameState();
}

class _OnboardingNameState extends State<OnboardingName> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_onNameChanged);
    lastNameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    firstNameController.removeListener(_onNameChanged);
    firstNameController.dispose();
    lastNameController.removeListener(_onNameChanged);
    lastNameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final auth = Provider.of<AccountProvider>(context, listen: false);
    if (auth.errorMessage.isNotEmpty) {
      auth.setError('');
    }
  }

  Future<void> _continueWithName() async {
    final cards = Provider.of<FidelityCardsProvider>(context, listen: false);
    final auth = Provider.of<AccountProvider>(context, listen: false);

    if (lastNameController.text.isEmpty) {
      auth.setError(AppLocalizations.of(context)!.no_last_name_entered);
    } else if (firstNameController.text.isEmpty) {
      auth.setError(AppLocalizations.of(context)!.no_first_name_entered);
    } else {
      await auth.addName(firstNameController.text, lastNameController.text);

      if (auth.errorMessage.isEmpty) {
        Timer(const Duration(milliseconds: 200), () {
          cards.initializeAccountCards(auth.token).then((_) async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool(
                'finishedOnboarding', true); // Set onboarding finished
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NavBar(pageIndex: 0)),
            );
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).shadowColor,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.person_rounded,
                      size: 30,
                      color: darkGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.onboarding_name_title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'SFProRounded',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.onboarding_name_subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'SFProRounded',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // const Text(
                //   "Nume",
                //   style: TextStyle(
                //       fontFamily: "SFProRounded",
                //       fontWeight: FontWeight.w600,
                //       fontSize: 18),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.familyName],
                        controller: lastNameController,
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
                          hintText: AppLocalizations.of(context)!
                              .onboarding_surname_hint,
                          hintStyle: const TextStyle(
                              fontSize: 18, fontFamily: 'UberMoveMedium'),
                        ),
                      ),
                    ],
                  ),
                ),
                // const Text(
                //   "Prenume",
                //   style: TextStyle(
                //       fontFamily: "SFProRounded",
                //       fontWeight: FontWeight.w600,
                //       fontSize: 18),
                // ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        keyboardType: TextInputType.name,
                        autofillHints: const [AutofillHints.givenName],
                        controller: firstNameController,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Theme.of(context).shadowColor,
                            filled: true,
                            hintText: AppLocalizations.of(context)!
                                .onboarding_firstname_hint,
                            hintStyle: const TextStyle(
                                fontSize: 18, fontFamily: 'UberMoveMedium')),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          auth.errorMessage,
                          style: const TextStyle(
                            fontSize: 17,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: GestureDetector(
              onTap: _continueWithName,
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
                      !auth.loading
                          ? SizedBox(
                              height: 30,
                              child: Text(
                                AppLocalizations.of(context)!.continue_button,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SFProRounded',
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
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
    });
  }
}
