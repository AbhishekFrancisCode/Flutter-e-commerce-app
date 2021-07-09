import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vismaya/models/customer.dart';
import 'package:vismaya/utils/constants.dart';

class PrefManager {
  SharedPreferences _preferences;
  static final PrefManager _singleton = PrefManager._internal();
  factory PrefManager() => _singleton;
  Future initialized;

  PrefManager._internal() {
    initialized = init();
  }

  init() async {
    if (_preferences != null) return _preferences;
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  String get customerToken => _preferences.getString(kPrefCustomerToken) ?? "";

  setCustomerToken(String value) async =>
      await _preferences.setString(kPrefCustomerToken, value);

  String get customerQuoteId =>
      _preferences.getString(kPrefCustomerQuoteId) ?? "";

  String get guestQuoteId => _preferences.getString(kPrefGuestQuoteId) ?? "";

  setCustomerQuoteId(String value) async =>
      await _preferences.setString(kPrefCustomerQuoteId, value);

  setGuestQuoteId(String value) async =>
      await _preferences.setString(kPrefGuestQuoteId, value);

  Customer get customerInfo {
    final source = _preferences.getString(kPrefCustomerInfo) ?? "{}";
    return Customer.fromJson(jsonDecode(source));
  }

  setCustomerInfo(Customer customer) async =>
      await _preferences.setString(kPrefCustomerInfo, customer.toJson());

  removeCustomerInfo() async => await _preferences.remove(kPrefCustomerInfo);
}

PrefManager prefManager = PrefManager();
