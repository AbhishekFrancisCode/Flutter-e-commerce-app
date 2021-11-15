import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/models/cart_total.dart';
import 'package:vismaya/models/payment.dart';
import 'package:vismaya/models/shipping_method.dart';

import 'address.dart';

class Cart {
  int itemsCount = 0;
  int itemsQty = 0;
  bool isActive = false;
  CartTotal cartTotal = CartTotal();
  List<CartItem> items = [];
  Address billingAddress = Address();
  Address shippingAddress = Address();
  List<ShippingMethod> shippingMethods = [];
  ShippingMethod selectedShippingMethod = ShippingMethod();
  Map<String, CartItem> skuCartMap = Map<String, CartItem>();
  Payment payment = Payment();

  Cart(
      {this.items = const [],
      this.itemsCount = 0,
      this.itemsQty = 0,
      this.isActive = false});

  CartItem getCartItemBySku(String sku) => skuCartMap[sku];

  void putCartItem(String sku, CartItem cartItem) => skuCartMap[sku] = cartItem;

  void removeCartItem(String sku) => skuCartMap.remove(sku);

  factory Cart.fromJson(dynamic json) {
    final isActive = json["is_active"];
    final list = json["items"] as List;
    final _items = list.map((e) => CartItem.fromResponseJson(e)).toList();

    final cart = Cart(
        items: _items,
        itemsCount: json["items_count"],
        itemsQty: json["items_qty"],
        isActive: isActive);

    _items.forEach((e) {
      cart.skuCartMap[e.sku] = e;
    });

    //Read billing address
    final billing = json["billing_address"];
    if (billing != null) {
      cart.billingAddress = Address.fromJson(billing);
    }
    //Read shipping address
    final extensionAttributes = json["extension_attributes"];
    if (extensionAttributes != null) {
      final shippingAssignments =
          extensionAttributes["shipping_assignments"] as List;
      if (shippingAssignments.isNotEmpty) {
        final shipping = shippingAssignments[0]["shipping"];
        if (shipping != null) {
          final address = shipping["address"];
          cart.shippingAddress = Address.fromJson(address);
        }
      }
    }
    return cart;
  }
}
