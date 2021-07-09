import 'dart:convert';

import 'package:vismaya/utils/utils.dart';

class CartItem {
  int itemId = 0;
  String sku = "";
  int qty = 0;
  String name = "";
  double price = 0;
  String productType = "";
  String quoteId = "";
  String brand = "";
  String imageUrl = "";
  String size = "";

  CartItem(
      {this.itemId = 0,
      this.sku = "",
      this.qty = 0,
      this.name = "",
      this.price = 0.0,
      this.productType = "",
      this.quoteId = "",
      this.brand = "",
      this.imageUrl = "",
      this.size = ""});

  String formattedPrice() => "Rs ${Utils.trucateIfZero(price)}";

  factory CartItem.fromResponseJson(dynamic json) {
    final attrs = json["extension_attributes"];
    final _imageUrl = attrs != null ? attrs["image_url"] : "";
    return CartItem(
        itemId: json["item_id"],
        sku: json["sku"],
        qty: json["qty"],
        name: json["name"],
        price: Utils.getDouble(json['price']),
        productType: json["product_type"],
        quoteId: json["quote_id"],
        imageUrl: _imageUrl ?? "");
  }

  String toPayloadJson() => jsonEncode({
        "cart_item": {"sku": sku, "qty": qty, "quote_id": quoteId}
      });

  String toUpdatePayloadJson() => jsonEncode({
        "cart_item": {"item_id": itemId, "qty": qty, "quote_id": quoteId}
      });
}
