import 'dart:convert';

import 'package:Stash/models/store.dart';
import 'package:Stash/utils/preferences.dart';
import 'package:Stash/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Map<String, Store> extractStores(List<Store> rawStores) {
  Map<String, Store> stores = {};

  for (int i = 0; i < rawStores.length; i++) {
    stores[rawStores[i].id] = rawStores[i];
  }

  return stores;
}

class StoresProvider with ChangeNotifier {
  List<Store> rawStores = [];
  Map<String, Store> stores = {};

  StoresProvider() {
    loadStores();
  }

  loadStores() async {
    rawStores = await getStores();
    stores = extractStores(rawStores);
    notifyListeners();

    if (rawStores.isEmpty) {
      await fetchStores();
    }
  }

  fetchStores() async {
    final res = await http.get(
      Uri.parse('$apiURL/stores'),
      headers: basicHeader,
    );

    final body = json.decode(utf8.decode(res.bodyBytes));
    final statusCode = res.statusCode;

    if (statusCode == 200) {
      rawStores = [];
      for (int i = 0; i < body.length; i++) {
        rawStores.add(Store.fromJSON(body[i]));
      }
      stores = extractStores(rawStores);
      setStores(body);
      notifyListeners();
    }
  }
}
