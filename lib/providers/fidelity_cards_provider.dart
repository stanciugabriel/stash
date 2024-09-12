import 'dart:convert';

import 'package:Stash/models/fidelity_card.dart';
import 'package:Stash/utils/preferences.dart';
import 'package:Stash/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FidelityCardsProvider with ChangeNotifier {
  List<FidelityCard> cards = [];

  // general signals
  bool loading = false;
  String errorMessage = '';

  loadCards() async {
    cards = await getCards();
    notifyListeners();
  }

  setLoading(bool newLoading) {
    loading = newLoading;
    notifyListeners();
  }

  setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  addFidelityCard(String token, FidelityCard card) async {
    if (token != '') {
      await postAddFidelityCard(token, card);
    } else {
      cards.add(card);
      notifyListeners();
    }
    setCards(cards);
  }

  postAddFidelityCard(String token, FidelityCard card) async {
    setLoading(true);

    final res = await http.post(Uri.parse('$apiURL/cards'),
        headers: authHeader(token), body: jsonEncode(card.toJSON()));

    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      cards = body.map((c) => FidelityCard.fromJSON(c));
      notifyListeners();

      setCards(cards);
    } else {
      setError(body['message']);
    }
  }

  fetchFidelityCards(String token) async {
    setLoading(true);

    final res =
        await http.get(Uri.parse('$apiURL/cards'), headers: authHeader(token));

    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      cards = body.map((c) => FidelityCard.fromJSON(c));
      notifyListeners();

      setCards(cards);
    } else {
      setError(body['message']);
    }
  }
}
