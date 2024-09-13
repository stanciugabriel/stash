import 'package:flutter/material.dart';
import 'package:Stash/models/loyalty_cards.dart'; // Assuming this is where your LoyaltyCard and CardStorage are

class CardProvider with ChangeNotifier {
  List<LoyaltyCard> _cards = [];

  List<LoyaltyCard> get cards => _cards;

  CardProvider() {
    _loadCards();
  }

  Future<void> _loadCards() async {
    _cards = await CardStorage.getCards();
    notifyListeners(); // Update the UI when cards are loaded
  }

  Future<void> addCard(LoyaltyCard card) async {
    _cards.add(card);
    await CardStorage.saveCards(_cards);
    notifyListeners();
  }

  Future<void> removeCard(LoyaltyCard card) async {
    _cards.removeWhere((c) => c.barcode == card.barcode);

    await CardStorage.saveCards(_cards);

    notifyListeners(); // Update the UI
  }
}
