import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:flutter/material.dart';

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
      return [Card(barcode: "8572085538", name: "Penny", format: "code-128")];
    }

    final List<dynamic> cardsList = jsonDecode(cardsJson);
    return cardsList.map((map) => Card.fromMap(map)).toList();
  }

  // Map to store card names with their color and logo
  static const Map<String, Map<String, dynamic>> cardDetails = {
    'Penny': {
      'color': Colors.red,
      'logo': 'assets/penny.svg',
    },
    'Sephora': {
      'color': Colors.white,
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/2/21/Sephora_logo.svg',
    },
    // Add other card names with their colors and logos
  };

  // Method to get card details based on card name
  static Map<String, dynamic>? getCardDetails(String name) {
    return cardDetails[name];
  }
}
