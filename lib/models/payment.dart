import 'package:vismaya/models/payment_method.dart';
import 'package:vismaya/models/payment_total_segment.dart';

class Payment {
  List<PaymentTotalSegment> totalSegments = [];
  List<PaymentMethod> paymentMethods = [];
  PaymentMethod selectedPaymentMethod;

  Payment();

  factory Payment.fromJson(dynamic json) {
    final _paymentMethods = json["payment_methods"] as List;
    final paymentMethodsList =
        _paymentMethods.map((e) => PaymentMethod.fromJson(e)).toList();
    Payment _payment = Payment();
    _payment.paymentMethods = paymentMethodsList;
    final _totals = json["totals"];
    if (_totals != null) {
      final _totalSegments = _totals["total_segments"] as List;
      _payment.totalSegments =
          _totalSegments.map((e) => PaymentTotalSegment.fromJson(e)).toList();
    }
    return _payment;
  }
}
