import 'dart:convert';

import 'package:Stash/models/fidelity_card.dart';
import 'package:Stash/utils/preferences.dart';
import 'package:Stash/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FidelityCardsProvider with ChangeNotifier {
  // all usable, locally stored cards
  List<FidelityCard> cards = [];

  // cards being added
  FidelityCard addCard = FidelityCard.fromEmpty();
  String deleteCard = '';
  UpdateFidelityCard updateCard = UpdateFidelityCard.fromEmpty();

  // cards not yet synced with backend
  List<FidelityCard> addQueue = [];
  List<String> deleteQueue = [];
  List<UpdateFidelityCard> updateQueue = [];

  // general signals
  bool loading = false;
  String errorMessage = '';

  FidelityCardsProvider() {
    loadCards();
  }

  Future<void> loadCards() async {
    cards = await getCards();

    addQueue = await getAddQueue();
    deleteQueue = await getDeleteQueue();
    updateQueue = await getUpdateQueue();

    notifyListeners();
  }

  sweepAll(String token) async {
    await sweepAddQueue(token);
    await sweepDeleteQueue(token);
    await sweepUpdateQueue(token);
  }

  setLoading(bool newLoading) {
    loading = newLoading;
    notifyListeners();
  }

  setError(String message) {
    errorMessage = message;
    notifyListeners();
  }

  addCardInitialize(String accountID) async {
    addCard = FidelityCard.init(accountID);
    notifyListeners();
  }

  addCardAttachBarcode(String code, String format) async {
    addCard.code = code;
    addCard.format = format;

    notifyListeners();
  }

  addCardAttachStore(String storeID) async {
    addCard.storeID = storeID;

    notifyListeners();
  }

  addCardAttachNickname(String nickname) async {
    addCard.nickname = nickname;

    notifyListeners();
  }

  deleteCardSet(String id) {
    deleteCard = id;

    notifyListeners();
  }

  updateCardSet(String id, String nickname) {
    updateCard = UpdateFidelityCard(id: id, nickname: nickname);

    notifyListeners();
  }

  addFidelityCard(String token) async {
    if (token != '') {
      // adding the card to the queue
      pushAddQueue();

      // trying to sweep the queue
      await sweepAddQueue(token);
    }

    // adding the card to the active cards
    commitAddCard();

    // deleting the add card
    addCard = FidelityCard.fromEmpty();
    notifyListeners();
  }

  Future<void> deleteFidelityCard(String token) async {
    if (token != '') {
      // adding the delete to the queue
      pushDeleteQueue();

      // trying to sweep the queu
      await sweepDeleteQueue(token);
    }

    // deleting the card from the active cards
    commitDeleteCard();

    // deleting the delete card
    deleteCard = '';
    notifyListeners();
  }

  updateFidelityCard(String token) async {
    if (token != '') {
      // adding the update to the queue
      pushUpdateQueue();

      // trying to sweep the queue
      await sweepUpdateQueue(token);
    }

    // updating the card to the active cards
    commitUpdateCard();

    // deleting the update card
    updateCard = UpdateFidelityCard.fromEmpty();
    notifyListeners();
  }

  pushAddQueue() {
    addQueue.add(addCard);
    setAddQueue(addQueue);
    notifyListeners();
  }

  pushDeleteQueue() {
    deleteQueue.add(deleteCard);
    setDeleteQueue(deleteQueue);
    notifyListeners();
  }

  pushUpdateQueue() {
    updateQueue.add(updateCard);
    setUpdateQueue(updateQueue);
    notifyListeners();
  }

  commitAddCard() {
    cards.add(addCard);
    setCards(cards);
    notifyListeners();
  }

  commitDeleteCard() {
    List<FidelityCard> newCards = [];
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].id != deleteCard) {
        newCards.add(cards[i]);
      }
    }
    setCards(newCards);
    cards = newCards;
    notifyListeners();
  }

  commitUpdateCard() {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].id == updateCard.id) {
        cards[i].nickname = updateCard.nickname;
      }
    }
    setCards(cards);
    notifyListeners();
  }

  clearAddQueue() {
    addQueue = [];
    removeAddQueue();
    notifyListeners();
  }

  clearDeleteQueue() {
    deleteQueue = [];
    removeDeleteQueue();
    notifyListeners();
  }

  clearUpdateQueue() {
    updateQueue = [];
    removeUpdateQueue();
    notifyListeners();
  }

  sweepAddQueue(String token) async {
    setLoading(true);

    List<Map<String, String>> queueJSON = [];
    for (int i = 0; i < addQueue.length; i++) {
      queueJSON.add(addQueue[i].toJSON());
    }

    final res = await http.post(Uri.parse('$apiURL/cards'),
        headers: authHeader(token), body: jsonEncode(queueJSON));

    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      clearAddQueue();
    }
  }

  sweepDeleteQueue(String token) async {
    setLoading(true);

    final res = await http.delete(Uri.parse('$apiURL/cards'),
        headers: authHeader(token), body: jsonEncode(deleteQueue));

    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      clearDeleteQueue();
    }
  }

  sweepUpdateQueue(String token) async {
    setLoading(true);

    List<Map<String, String>> queueJSON = [];
    for (int i = 0; i < updateQueue.length; i++) {
      queueJSON.add(updateQueue[i].toJSON());
    }

    final res = await http.patch(Uri.parse('$apiURL/cards'),
        headers: authHeader(token), body: jsonEncode(queueJSON));

    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      clearUpdateQueue();
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
      cards = [];
      for (int i = 0; i < body.length; i++) {
        cards.add(FidelityCard.fromJSON(body[i]));
      }
      notifyListeners();

      setCards(cards);
    } else {
      setError(body['message']);
    }
  }
}
