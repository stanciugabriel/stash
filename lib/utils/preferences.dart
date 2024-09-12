import 'dart:convert';

import 'package:cardnest/models/account.dart';
import 'package:cardnest/models/fidelity_card.dart';
import 'package:cardnest/models/store.dart';
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

Future<List<Store>> getStores() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final storesString = prefs.getString('stores') ?? '';

  List<dynamic> storesList = jsonDecode(storesString);
  return storesList.map((s) => Store.fromJSON(s)).toList();
}

void setStores(List<dynamic> stores) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('stores', jsonEncode(stores));
}
