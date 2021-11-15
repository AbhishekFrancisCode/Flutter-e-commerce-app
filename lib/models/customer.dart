import 'dart:convert';

import 'package:vismaya/models/address.dart';

class Customer {
  int id = 0;
  String firstname = "";
  String lastname = "";
  String email = "";
  bool isSubscribed = false;
  int storeId = 0;
  int websiteId = 0;
  List<Address> addresses;
  bool hasSavedAddresses = false;

  Customer(
      {this.id = 0,
      this.firstname = "",
      this.lastname = "",
      this.email = "",
      this.isSubscribed = false,
      this.addresses = const [],
      this.storeId = 1,
      this.websiteId = 1,
      this.hasSavedAddresses = false});

  factory Customer.fromJson(dynamic json) {
    final jsonAddrList = json["addresses"] as List ?? [];
    final _addresses =
        jsonAddrList.map((e) => Address.fromCustomerJson(e)).toList();
    final hasSavedAddress = json["has_saved_addresses"] ?? false;
    return Customer(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        storeId: json["store_id"],
        websiteId: json["website_id"] ?? 1,
        hasSavedAddresses: _addresses.isNotEmpty || hasSavedAddress,
        addresses: _addresses);
  }

  String toJson() => jsonEncode({
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "is_subscribed": isSubscribed,
        "store_id": storeId,
        "website_id": websiteId,
        "has_saved_addresses": hasSavedAddresses
      });

  String toRequestJson() => jsonEncode({
        "customer": {
          "firstname": firstname,
          "lastname": lastname,
          "email": email,
          "store_id": storeId,
          "website_id": websiteId,
          "addresses": addresses
              .where((e) => !e.isEmpty())
              .map((e) => e.toCustomerAddressJson())
              .toList()
        }
      });
}
