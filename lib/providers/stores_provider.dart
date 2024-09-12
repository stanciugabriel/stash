import 'dart:convert';

import 'package:Stash/models/store.dart';
import 'package:Stash/utils/preferences.dart';
import 'package:Stash/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoresProvider with ChangeNotifier {
  List<Store> stores = [];

  loadStores() async {
    stores = await getStores();
    notifyListeners();
  }

  fetchStores() async {
    final res = await http.get(
      Uri.parse('$apiURL/stores'),
      headers: basicHeader,
    );

    final body = json.decode(utf8.decode(res.bodyBytes));
    final statusCode = res.statusCode;

    if (statusCode == 200) {
      stores = [];
      for (int i = 0; i < body.length; i++) {
        stores.add(Store.fromJSON(body[i]));
      }
      setStores(body);
      notifyListeners();
    }
  }
}
