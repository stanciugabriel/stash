import 'dart:convert';

import 'package:cardnest/models/account.dart';
import 'package:cardnest/utils/preferences.dart';
import 'package:cardnest/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccountProvider with ChangeNotifier {
  // temporary values used for onboarding
  String phoneNumber = '';
  String token = '';
  bool newClient = false;

  // general signals
  bool loading = false;
  String errorMessage = '';

  Account account = Account.fromEmpty();

  loadAccount() async {
    token = await getToken();
    account = await getAccount();

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

  Future<void> onboarding(String phone) async {
    phoneNumber = phone;

    setLoading(true);
    final res = await http.post(Uri.parse('$apiURL/accounts/onboarding'),
        headers: basicHeader,
        body: jsonEncode(<String, String>{
          'phone': phone,
        }));

    final body = json.decode(utf8.decode(res.bodyBytes));
    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      newClient = body['newClient'];
      token = body['token'];

      setError('');
    } else {
      setError(body['message']);
    }
  }

  Future<void> verifyCode(String code) async {
    setLoading(true);
    final res =
        await http.post(Uri.parse('$apiURL/accounts/onboarding/verify-code'),
            headers: authHeader(token),
            body: jsonEncode(<String, dynamic>{
              'code': code,
              'newClient': newClient,
            }));

    final body = json.decode(utf8.decode(res.bodyBytes));
    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      token = body['token'];
      setToken(token);

      account = Account.fromJSON(body['account']);
      setAccount(account);
      account = await getAccount();

      setError('');
    } else {
      setError(body['message']);
    }
  }

  Future<void> addName(String firstName, String lastName) async {
    setLoading(true);
    final res = await http.post(Uri.parse('$apiURL/accounts/onboarding/name'),
        headers: authHeader(token),
        body: jsonEncode(<String, dynamic>{
          'firstName': firstName,
          'lastName': lastName,
        }));

    final body = json.decode(utf8.decode(res.bodyBytes));
    final statusCode = res.statusCode;

    setLoading(false);

    if (statusCode == 200) {
      token = body['token'];
      setToken(token);

      account = Account.fromJSON(body['account']);
      setAccount(account);
      account = await getAccount();

      setError('');
    } else {
      setError(body['message']);
    }
  }

  logout() async {
    account = Account.fromEmpty();
    token = '';
    notifyListeners();

    removeAccount();
    removeToken();
  }
}
