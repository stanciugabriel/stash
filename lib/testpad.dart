import 'package:Stash/providers/account_provider.dart';
import 'package:Stash/providers/fidelity_cards_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Testpad extends StatefulWidget {
  const Testpad({super.key});

  @override
  State<Testpad> createState() => _TestpadState();
}

class _TestpadState extends State<Testpad> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
      return Consumer<FidelityCardsProvider>(builder: (context, cards, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                print(auth.token);
                              },
                              child: const Text("See token")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await auth.onboarding("+40712345678");
                                await auth.verifyCode("0000");
                                await auth.addName("New", "Client");

                                await cards.initializeAccountCards(auth.token);

                                print(auth.account.id);
                              },
                              child: const Text("Create account")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await auth.onboarding("+40723010405");
                                await auth.verifyCode("0000");
                                await cards.fetchFidelityCards(auth.token);

                                print(auth.account.id);
                              },
                              child: const Text("Login")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await auth.logout();
                                await cards.unloadCards();
                                print(auth.account.id);
                              },
                              child: const Text("Logout")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                print(auth.account.id);
                              },
                              child: const Text("Whoami")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await cards.loadCards();
                                for (int i = 0; i < cards.cards.length; i++) {
                                  print(cards.cards[i].id);
                                }
                              },
                              child: const Text("Load cards")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                for (int i = 0; i < cards.cards.length; i++) {
                                  print(cards.cards[i].id);
                                }
                              },
                              child: const Text("See cards")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await cards.fetchFidelityCards(auth.token);
                                for (int i = 0; i < cards.cards.length; i++) {
                                  print(cards.cards[i].id);
                                }
                              },
                              child: const Text("Fetch cards")),
                          const SizedBox(height: 20),

                          // SWEEP

                          GestureDetector(
                              onTap: () async {
                                await cards.sweepAll(auth.token);
                              },
                              child: const Text("Sweep all")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await cards.sweepAddQueue(auth.token);
                              },
                              child: const Text("Sweep addQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await cards.sweepDeleteQueue(auth.token);
                              },
                              child: const Text("Sweep deleteQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                await cards.sweepUpdateQueue(auth.token);
                              },
                              child: const Text("Sweep updateQueue")),
                          const SizedBox(height: 20),

                          // ADD CARD

                          GestureDetector(
                              onTap: () async {
                                await cards.addCardInitialize(auth.account.id);
                                await cards.addCardAttachStore("12345");

                                await cards.addFidelityCard(auth.token);
                                // for (int i = 0; i < cards.cards.length; i++) {
                                //   print(cards.cards[i].id);
                                // }
                              },
                              child: const Text("Add fidelity card")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                for (int i = 0;
                                    i < cards.addQueue.length;
                                    i++) {
                                  print(cards.addQueue[i].id);
                                }
                              },
                              child: const Text("Load addQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                for (int i = 0;
                                    i < cards.addQueue.length;
                                    i++) {
                                  print(cards.addQueue[i].id);
                                }
                              },
                              child: const Text("See addQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                cards.clearAddQueue();

                                for (int i = 0;
                                    i < cards.addQueue.length;
                                    i++) {
                                  print(cards.addQueue[i].id);
                                }
                              },
                              child: const Text("Remove addQueue")),
                          const SizedBox(height: 20),

                          // DELETE CARD

                          GestureDetector(
                              onTap: () async {
                                final card =
                                    cards.cards[cards.cards.length - 1].id;
                                print(card);
                                cards.deleteCardSet(card);
                                await cards.deleteFidelityCard(auth.token);
                              },
                              child: const Text("Remove fidelity card")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                for (int i = 0;
                                    i < cards.deleteQueue.length;
                                    i++) {
                                  print(cards.deleteQueue[i]);
                                }
                              },
                              child: const Text("Load deleteQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                for (int i = 0;
                                    i < cards.deleteQueue.length;
                                    i++) {
                                  print(cards.deleteQueue[i]);
                                }
                              },
                              child: const Text("See deleteQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                cards.clearDeleteQueue();

                                for (int i = 0;
                                    i < cards.deleteQueue.length;
                                    i++) {
                                  print(cards.deleteQueue[i]);
                                }
                              },
                              child: const Text("Remove deleteQueue")),
                          const SizedBox(height: 20),

                          // UPDATE CARD

                          GestureDetector(
                              onTap: () async {
                                final cardID =
                                    cards.cards[cards.cards.length - 1].id;
                                cards.updateCardSet(cardID, 'hello');
                                await cards.updateFidelityCard(auth.token);
                              },
                              child: const Text("Update fidelity card")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                for (int i = 0;
                                    i < cards.updateQueue.length;
                                    i++) {
                                  print(cards.updateQueue[i]);
                                }
                              },
                              child: const Text("Load updateQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                for (int i = 0;
                                    i < cards.updateQueue.length;
                                    i++) {
                                  print(cards.updateQueue[i]);
                                }
                              },
                              child: const Text("See updateQueue")),
                          const SizedBox(height: 20),
                          GestureDetector(
                              onTap: () async {
                                cards.clearDeleteQueue();

                                for (int i = 0;
                                    i < cards.updateQueue.length;
                                    i++) {
                                  print(cards.updateQueue[i]);
                                }
                              },
                              child: const Text("Remove updateQueue")),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        );
      });
    });
  }
}
