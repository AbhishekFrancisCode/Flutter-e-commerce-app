import 'package:vismaya/utils/utils.dart';

class ShippingMethod {
  String methodTitle = "";
  String methodCode = "";
  String carrierCode = "";
  String carrierTitle = "";
  bool available = false;
  double amount = 0;
  double baseAmount = 0;
  double priceExclTax = 0;
  double priceInclTax = 0;

  ShippingMethod(
      {this.methodTitle = "",
      this.methodCode = "",
      this.carrierCode = "",
      this.carrierTitle = "",
      this.available = false,
      this.amount = 0,
      this.baseAmount = 0,
      this.priceExclTax = 0,
      this.priceInclTax = 0});

  String getDisplayTitle() {
    if (amount > 0) {
      final _amount = Utils.getDouble(amount);
      return "$carrierTitle  —  Rs $_amount";
    } else {
      return carrierTitle;
    }
  }

  factory ShippingMethod.fromJson(dynamic json) {
    return ShippingMethod(
      methodTitle: json["method_title"],
      methodCode: json["method_code"],
      carrierTitle: json["carrier_title"],
      carrierCode: json["carrier_code"],
      available: json["available"],
      amount: Utils.getDouble(json["amount"]),
      baseAmount: Utils.getDouble(json["base_amount"]),
      priceExclTax: Utils.getDouble(json["price_excl_tax"]),
      priceInclTax: Utils.getDouble(json["price_incl_tax"]),
    );
  }
}
