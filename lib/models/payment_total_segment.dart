import 'package:vismaya/utils/utils.dart';

class PaymentTotalSegment {
  final String code;
  final String title;
  final double value;
  PaymentTotalSegment({this.code, this.title, this.value});

  factory PaymentTotalSegment.fromJson(dynamic json) {
    return PaymentTotalSegment(
        code: json["code"],
        title: json["title"],
        value: Utils.getDouble(json["value"]));
  }
}
