import 'dart:convert';

class SelectedDeliveryTime {
  String quoteId = "";
  String dtimeId = "";
  String date = "";
  String comment = "";
  SelectedDeliveryTime(
      [this.date = "",
      this.dtimeId = "",
      this.comment = "",
      this.quoteId = ""]);

  String toRequestJson() {
    return jsonEncode({
      "schedule": {
        "quote_id": this.quoteId,
        "mw_delivery_date": this.date,
        "mw_delivery_time": this.dtimeId,
        "mw_delivery_comment": this.comment
      }
    });
  }
}
