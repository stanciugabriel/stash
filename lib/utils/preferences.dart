import 'dart:convert';

import 'package:Stash/models/account.dart';
import 'package:Stash/models/fidelity_card.dart';
import 'package:Stash/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TOKEN
Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? '';
}

void setToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

void removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

// ACCOUNT
Future<Account> getAccount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final accountString = prefs.getString("account") ?? '';
  var account = Account.fromEmpty();

  if (accountString != '') {
    account = Account.fromJSON(jsonDecode(accountString));
  }

  return account;
}

void setAccount(Account account) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('account', jsonEncode(account.toJSON()));
}

void removeAccount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove("account");
}

// FIDELITY CARDS
Future<List<FidelityCard>> getCards() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final cardsString = prefs.getString('fidelitycards') ?? '';

  List<dynamic> cardsList = jsonDecode(cardsString);
  return cardsList.map((c) => FidelityCard.fromJSON(c)).toList();
}

void setCards(List<FidelityCard> cards) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final cardsList = cards.map((c) => c.toJSON()).toList();
  final cardsString = jsonEncode(cardsList);
  await prefs.setString('fidelitycards', cardsString);
}

void removeCards() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('fidelitycards');
}

// ADD QUEUE CARDS
Future<List<FidelityCard>> getAddQueue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final cardsString = prefs.getString('addQueue') ?? '';

  List<dynamic> cardsList = jsonDecode(cardsString);
  return cardsList.map((c) => FidelityCard.fromJSON(c)).toList();
}

void setAddQueue(List<FidelityCard> cards) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final cardsList = cards.map((c) => c.toJSON()).toList();
  final cardsString = jsonEncode(cardsList);
  await prefs.setString('addQueue', cardsString);
}

void removeAddQueue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('addQueue');
}

// DELETE QUEUE CARDS
Future<List<String>> getDeleteQueue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final idsString = prefs.getString('removeQueue') ?? '';

  return jsonDecode(idsString);
}

void setDeleteQueue(List<String> ids) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final idsString = jsonEncode(ids);
  await prefs.setString('removeQueue', idsString);
}

void removeDeleteQueue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('addQueue');
}

// UPDATE QUEUE CARDS
Future<List<UpdateFidelityCard>> getUpdateQueue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final cardsString = prefs.getString('addQueue') ?? '';

  List<dynamic> cardsList = jsonDecode(cardsString);
  return cardsList.map((c) => UpdateFidelityCard.fromJSON(c)).toList();
}

void setUpdateQueue(List<UpdateFidelityCard> cards) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final cardsList = cards.map((c) => c.toJSON()).toList();
  final cardsString = jsonEncode(cardsList);
  await prefs.setString('addQueue', cardsString);
}

void removeUpdateQueue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('addQueue');
}

// STORES
Future<List<Store>> getStores() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final storesString = prefs.getString('stores') ?? '';

  if (storesString == '') {
    return [];
  }

  List<dynamic> storesList = jsonDecode(storesString);
  return storesList.map((s) => Store.fromJSON(s)).toList();
}

void setStores(List<dynamic> stores) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('stores', jsonEncode(stores));
}

void removeStores() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('stores');
}
