import 'dart:convert';

import 'package:vismaya/models/clonable.dart';

class Address implements Clonable {
  int id = 0;
  String firstname = "";
  String lastname = "";
  String email = "";
  String telephone = "";
  String countryId = "";
  List<String> streets = [];
  String city = "";
  String region = "";
  int regionId = 0;
  String regionCode = "";
  String postcode = "";
  bool defaultShipping = false;
  bool defaultBilling = false;
  int saveInAddressBook = 0;

  Address(
      {this.id = 0,
      this.firstname = "",
      this.lastname = "",
      this.email = "",
      this.telephone = "",
      this.countryId = "",
      this.streets = const [],
      this.city = "",
      this.region = "",
      this.regionId = 0,
      this.regionCode = "",
      this.postcode = "",
      this.defaultShipping = false,
      this.defaultBilling = false,
      this.saveInAddressBook = 0});

  String toString() {
    final sb = StringBuffer()
      ..writeln("$firstname $lastname".trim())
      ..writeln(streets.join('\n').trim())
      ..writeln("$city, $region".trim())
      ..writeln(postcode.trim());
    if (email != null && email.isNotEmpty) {
      sb.writeln(email);
    }
    sb.writeln(telephone.trim());
    return sb.toString();
  }

  factory Address.fromCustomerJson(dynamic json) {
    final _streets = json["street"] as List ?? [];
    final _streetList = _streets.cast<String>().toList();
    final region = json["region"] as Map ?? {};
    return Address(
        id: json["id"] ?? 0,
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        telephone: json["telephone"],
        countryId: json["country_id"],
        streets: _streetList,
        city: json["city"],
        region: region["region"],
        regionId: json["region_id"],
        regionCode: region["region_code"],
        postcode: json["postcode"],
        defaultShipping: json["default_shipping"] ?? false,
        defaultBilling: json["default_billing"] ?? false,
        saveInAddressBook: json["save_in_address_book"] ?? 0);
  }

  factory Address.fromJson(dynamic json) {
    final _streets = json["street"] as List ?? [];
    final _streetList = _streets.cast<String>().toList();
    return Address(
        id: json["id"] ?? 0,
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        telephone: json["telephone"],
        countryId: json["country_id"],
        streets: _streetList,
        city: json["city"],
        region: json["region"],
        regionId: json["region_id"],
        regionCode: json["region_code"],
        postcode: json["postcode"],
        saveInAddressBook: json["save_in_address_book"] ?? 0);
  }

  String toJson() {
    return jsonEncode({
      "address": {
        "firstname": this.firstname,
        "lastname": this.lastname,
        "email": this.email,
        "telephone": this.telephone,
        "region": this.region,
        "region_id": this.regionId,
        "region_code": this.regionCode,
        "country_id": this.countryId,
        "street": this.streets,
        "postcode": this.postcode,
        "city": this.city
      }
    });
  }

  dynamic toAddressJson() {
    return {
      "firstname": this.firstname,
      "lastname": this.lastname,
      "email": this.email,
      "telephone": this.telephone,
      "region": this.region,
      "region_id": this.regionId,
      "region_code": this.regionCode,
      "country_id": this.countryId,
      "street": this.streets,
      "postcode": this.postcode,
      "city": this.city,
      "save_in_address_book": this.saveInAddressBook
    };
  }

  dynamic toCustomerAddressJson() {
    return {
      "firstname": this.firstname,
      "lastname": this.lastname,
      // "email": this.email,
      "telephone": this.telephone,
      "region": this.region,
      "region_id": this.regionId,
      // "region_code": this.regionCode,
      "country_id": this.countryId,
      "street": this.streets,
      "postcode": this.postcode,
      "city": this.city,
      "default_shipping": this.defaultShipping,
      "default_billing": this.defaultBilling
    };
  }

  bool isEmpty() => region == null || region.isEmpty;

  @override
  clone() {
    return Address(
        id: id,
        firstname: firstname,
        lastname: lastname,
        email: email,
        telephone: telephone,
        countryId: countryId,
        streets: streets.map((e) => e).toList(),
        city: city,
        region: region,
        regionId: regionId,
        regionCode: regionCode,
        postcode: postcode,
        defaultShipping: defaultShipping,
        defaultBilling: defaultShipping,
        saveInAddressBook: saveInAddressBook);
  }
}
