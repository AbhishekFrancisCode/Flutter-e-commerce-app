import 'package:vismaya/utils/utils.dart';

class CartTotal {
  double grandTotal = 0;
  double discount = 0;
  double subtotal = 0;

  CartTotal({this.grandTotal = 0, this.discount = 0, this.subtotal = 0});

  factory CartTotal.fromResponseJson(dynamic json) {
    return CartTotal(
        grandTotal: Utils.getDouble(json["grand_total"]),
        subtotal: Utils.getDouble(json["subtotal"]),
        discount: Utils.getDouble(json["discount_amount"]));
  }
}
