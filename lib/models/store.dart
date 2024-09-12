import 'package:cardnest/utils/convert.dart';
import 'package:flutter/material.dart';

class Store {
  String id;
  String name;
  Color color;

  Store({
    required this.id,
    required this.name,
    required this.color,
  });

  factory Store.fromEmpty() {
    return Store(
      id: '',
      name: '',
      color: Colors.white,
    );
  }

  factory Store.fromJSON(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: convertHex(json['color'] ?? '#ffffff'),
    );
  }
}
