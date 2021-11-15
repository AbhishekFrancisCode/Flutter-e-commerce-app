class OrderDetails {
  final String orderId;
  OrderDetails({this.orderId = ""});

  factory OrderDetails.fromJson(dynamic json) {
    return OrderDetails(orderId: json["order_id"]);
  }
}
