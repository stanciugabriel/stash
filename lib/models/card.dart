import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode

class Card {
  String barcode;
  String name;
  String format;

  Card({required this.barcode, required this.name, required this.format});

  // Convert a Card instance to a map
  Map<String, dynamic> toMap() {
    return {'barcode': barcode, 'name': name, 'format': format};
  }

  // Convert a map to a Card instance
  factory Card.fromMap(Map<String, dynamic> map) {
    return Card(
      barcode: map['barcode'],
      name: map['name'],
      format: map['format'],
    );
  }
}

class CardStorage {
  static const String _cardsKey = 'cards';

  // Save a list of cards to SharedPreferences
  static Future<void> saveCards(List<Card> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> cardsMap =
        cards.map((card) => card.toMap()).toList();
    final String cardsJson = jsonEncode(cardsMap);
    await prefs.setString(_cardsKey, cardsJson);
  }

  // Retrieve a list of cards from SharedPreferences
  static Future<List<Card>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString(_cardsKey);

    if (cardsJson == null) {
      return [];
    }

    final List<dynamic> cardsList = jsonDecode(cardsJson);
    return cardsList.map((map) => Card.fromMap(map)).toList();
  }
}
