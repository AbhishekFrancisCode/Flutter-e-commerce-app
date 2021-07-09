class PaymentMethod {
  final String code;
  final String title;
  PaymentMethod({this.code, this.title});

  factory PaymentMethod.fromJson(dynamic json) {
    return PaymentMethod(code: json["code"], title: json["title"]);
  }
}
