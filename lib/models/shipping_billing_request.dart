import 'dart:convert';

import 'package:vismaya/models/address.dart';

class ShippingBillingRequest {
  final Address shippingAddress;
  final Address billingAddress;
  final String shippingCarrierCode;
  final String shippingMethodCode;

  ShippingBillingRequest(this.shippingAddress, this.billingAddress,
      this.shippingCarrierCode, this.shippingMethodCode);

  String toJson() {
    return jsonEncode({
      "addressInformation": {
        "shipping_address": shippingAddress.toAddressJson(),
        "billing_address": billingAddress.toAddressJson(),
        "shipping_carrier_code": shippingCarrierCode,
        "shipping_method_code": shippingMethodCode
      }
    });
  }
}
