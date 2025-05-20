import 'package:Stash/onboarding/onboarding_code.dart';
import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/utils/vars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPhone extends StatefulWidget {
  const OnboardingPhone({super.key});

  @override
  State<OnboardingPhone> createState() => _OnboardingPhoneState();
}

class _OnboardingPhoneState extends State<OnboardingPhone> {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneNumberController.addListener(_onPhoneNumberChanged);
  }

  @override
  void dispose() {
    phoneNumberController.removeListener(_onPhoneNumberChanged);
    phoneNumberController.dispose();
    super.dispose();
  }

  void _onPhoneNumberChanged() {
    final phoneNumber = phoneNumberController.text;
    final auth = Provider.of<AccountProvider>(context, listen: false);

    if (phoneNumber.length != 10 && phoneNumber.isNotEmpty) {
      auth.setError(AppLocalizations.of(context)!.incorrect_phone_number);
    } else {
      auth.setError('');
    }
  }

  Future<void> _continueWithPhoneNumber() async {
    final auth = Provider.of<AccountProvider>(context, listen: false);
    String phoneNumber = "+4${phoneNumberController.text}";

    if (phoneNumberController.text.length == 10) {
      auth.onboarding(phoneNumber).then((_) {
        if (auth.errorMessage == '') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingCode()),
          );
        }
      });
    } else {
      await auth.setError(AppLocalizations.of(context)!.incorrect_phone_number);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
      return Scaffold(
        body: Stack(
          children: [
            SafeArea(
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
                          Icons.sms_rounded,
                          size: 30,
                          color: darkGrey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      AppLocalizations.of(context)!.continue_with_phone_number,
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'SFProRounded',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .login_or_register_with_phone,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'SFProRounded',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            keyboardType: TextInputType.phone,
                            autofillHints: const [
                              AutofillHints.telephoneNumberNational
                            ],
                            controller: phoneNumberController,
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
                                    .onboarding_phone_hint,
                                hintStyle: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'UberMoveMedium')),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: GestureDetector(
                    onTap: _continueWithPhoneNumber,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: blitzPurple,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !auth.loading
                                ? Text(
                                    AppLocalizations.of(context)!
                                        .continue_button,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'SFProRounded',
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
            ),
          ],
        ),
      );
    });
  }
}
