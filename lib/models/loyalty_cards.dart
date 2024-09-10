import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode
import 'package:flutter/material.dart';

class LoyaltyCard {
  String barcode;
  String name;
  String format;

  LoyaltyCard({
    required this.barcode,
    required this.name,
    required this.format,
  });

  // Convert a LoyaltyCard instance to a map
  Map<String, String> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'format': format,
    };
  }

  // Convert a map to a LoyaltyCard instance
  factory LoyaltyCard.fromMap(Map<String, dynamic> map) {
    return LoyaltyCard(
      barcode: map['barcode'] ?? '',
      name: map['name'] ?? '',
      format: map['format'] ?? '',
    );
  }
}

class CardStorage {
  static const String _cardsKey = 'cards';
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences only once
  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save a list of cards to SharedPreferences
  static Future<void> saveCards(List<LoyaltyCard> cards) async {
    await _initPrefs();
    try {
      final cardsMap = cards.map((card) => card.toMap()).toList();
      final cardsJson = jsonEncode(cardsMap);
      await _prefs?.setString(_cardsKey, cardsJson);
    } catch (e) {
      print('Error saving cards: $e');
    }
  }

  // Retrieve a list of cards from SharedPreferences
  static Future<List<LoyaltyCard>> getCards() async {
    await _initPrefs();
    final cardsJson = _prefs?.getString(_cardsKey);

    if (cardsJson == null || cardsJson.isEmpty) {
      return [
        LoyaltyCard(
            barcode: "barcode",
            name: "Intersport",
            format: "BarcodeFormat.code128"),
      ];
    }

    try {
      final List<dynamic> cardsList = jsonDecode(cardsJson);
      return cardsList.map((map) => LoyaltyCard.fromMap(map)).toList();
    } catch (e) {
      print('Error decoding cards: $e');
      return [];
    }
  }

  // Map to store card names with their color and logo
  static const Map<String, Map<String, dynamic>> cardDetails = {
    'Penny': {
      'color': Color(0xFFCD1515),
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Penny-Logo.svg/512px-Penny-Logo.svg.png',
    },
    'DrMax': {
      'color': Color(0xFF78BE1F),
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTT9sIBxpctYGzb7c4gA3pwzG50_pN32yzE4w&s',
    },
    'Cador': {
      'color': Color(0xFFFE6600),
      'logo':
          'https://www.sibieni.ro/upload/photo_sb/2022-08/cador-home-sibiu_large.png',
    },
    'Sensiblu': {
      'color': Color(0xFF0972CE),
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkG4WhvgYknUzk-8-zhYuS-SJz53J8V1TS2w&s',
    },
    'Optiblu': {
      'color': Color(0xFF015696),
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZfz2IQttlNSNjLEqvn6WOcLlMwBpbz9r-qQ&s',
    },
    'Sephora': {
      'color': Color(0xFF000000),
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS66_yGOYOUuXlqxpRx61gD_mql5UCmZUPtOw&s',
    },
    'Marionnaud': {
      'color': Color(0xFF71207F),
      'logo':
          'https://www.vipstyle.ro/wp-content/uploads/2018/03/Marionnaud_0.jpg',
    },
    'Cora': {
      'color': Colors.white,
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSn-ZF2zQDmocrQpOcTh5iIEuF8jRPAqRlaIA&s',
    },
    'Dona': {
      'color': Color(0xFFFFFFFF),
      'logo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReCpIKMCwtwbxc0OMvi5VE03Ot_6qC1x_2ug&s',
    },
    'Intersport': {
      'color': Color(0xFFFFFFFF),
      'logo':
          'https://koerber-supplychain.com/fileadmin/koerbersupplychain/Homepage/References/reference_intersport_logo.png',
    },
    'Decathlon': {
      'color': Color(0xFF324B9B),
      'logo':
          'https://images.seeklogo.com/logo-png/52/1/decathlon-logo-png_seeklogo-524475.png',
    },
    'Catena': {
      'color': Color(0xFF00824F),
      'logo':
          'https://hotnews.ro/wp-content/uploads/2024/04/image-2017-09-19-22009927-41-catena.jpg',
    },
    'Mega Image': {
      'color': Color(0xFFFFFFFF),
      'logo':
          'https://play-lh.googleusercontent.com/R0mrltwcHZwykHwkV6L9assLhAM9RMuTCOXD1P2klx4Occs8l-MEDu8hEXQo3CFwfXkE',
    },
    'Kaufland': {
      'color': Color(0xFFE10816),
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Kaufland_201x_logo.svg/1200px-Kaufland_201x_logo.svg.png',
    },
    'Lidl': {
      'color': Color(0xFF2351A7),
      'logo':
          'https://www.1min30.com/wp-content/uploads/2018/02/Symbole-Lidl.jpg',
    },
    // Add other card names with their colors and logos
  };

  // Method to get card details based on card name
  static Map<String, dynamic>? getCardDetails(String name) {
    return cardDetails[name];
  }
}
