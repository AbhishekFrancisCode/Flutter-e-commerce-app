import 'package:vismaya/utils/utils.dart';

class MyOrder {
  MyOrder({
    this.items,
    this.totalCount,
  });

  List<MyOrderItem> items;
  int totalCount;

  factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
        items: List<MyOrderItem>.from(
            json["items"].map((x) => MyOrderItem.fromJson(x))),
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "total_count": totalCount,
      };
}

class MyOrderItem {
  MyOrderItem({
    this.baseGrandTotal,
    this.baseShippingAmount,
    this.baseSubtotal,
    this.customerId,
    this.createdAt,  
    this.customerEmail,
    this.incrementId,
    this.quoteId,
    this.entityId,
    this.state,
    this.status,
    this.totalItemCount,
    this.totalQtyOrdered,
    this.weight,
    this.items,
    this.billingAddress,
    this.payment,
  });

  double baseGrandTotal;
  double baseShippingAmount;
  double baseSubtotal;
  double baseTaxAmount;
  DateTime createdAt; 
  int customerId;
  int entityId;
  String customerEmail;
  String incrementId;
  int quoteId;
  String state;
  String status;
  int totalItemCount;
  int totalQtyOrdered;
  double weight;
  List<ParentItemElement> items;
  Addresss billingAddress;
  Payments payment;

  factory MyOrderItem.fromJson(Map<String, dynamic> json) => MyOrderItem(
        baseGrandTotal: Utils.getDouble(json["base_grand_total"]),
        baseShippingAmount: Utils.getDouble(json["base_shipping_amount"]),
        baseSubtotal: Utils.getDouble(json["base_subtotal"]),
        createdAt: DateTime.parse(json["created_at"]),
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        entityId: json["entity_id"],
        customerEmail: json["customer_email"],
        incrementId: json["increment_id"],
        quoteId: json["quote_id"],
        state: json["state"],
        status: json["status"],
        totalItemCount: json["total_item_count"],
        totalQtyOrdered: json["total_qty_ordered"],
        weight: Utils.getDouble(json["weight"]),
        items: List<ParentItemElement>.from(json["items"].map((x) => ParentItemElement.fromJson(x))),
        billingAddress: Addresss.fromJson(json["billing_address"]),
        payment: Payments.fromJson(json["payment"]),
      );

  Map<String, dynamic> toJson() => {
        "base_grand_total": baseGrandTotal,
        "base_shipping_amount": baseShippingAmount,
        "base_subtotal": baseSubtotal,
        "base_tax_amount": baseTaxAmount,
        "created_at": createdAt.toString(),
        "customer_id": customerId == null ? null : customerId,
        "entity_id": entityId,
        "customer_email": customerEmail,
        "increment_id": incrementId,
        "quote_id": quoteId,
        "state": state,
        "status": status,
        "total_item_count": totalItemCount,
        "total_qty_ordered": totalQtyOrdered,
        "weight": weight,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "billing_address": billingAddress.toJson(),
        "payment": payment.toJson(),
      };
}


class Addresss {
  Addresss({
    this.city,
    this.countryId,
    this.email,
    this.firstname,
    this.lastname,
    this.parentId,
    this.postcode,
    this.region,
    this.regionCode,
    this.regionId,
    this.street,
    this.telephone,
  });

  String city;
  String countryId;
  String email;
  String firstname;
  String lastname;
  int parentId;
  String postcode;
  String region;
  RegionCode regionCode;
  int regionId;
  List<String> street;
  String telephone;

  factory Addresss.fromJson(Map<String, dynamic> json) => Addresss(
        city: json["city"],
        countryId: json["country_id"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        parentId: json["parent_id"],
        postcode: json["postcode"],
        region: json["region"],
        regionCode: regionCodeValues.map[json["region_code"]],
        regionId: json["region_id"],
        street: List<String>.from(json["street"].map((x) => x)),
        telephone: json["telephone"],
      );

  Map<String, dynamic> toJson() => {
        "city": cityValues.reverse[city],
        "country_id": countryId,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "parent_id": parentId,
        "postcode": postcode,
        "region": region,
        "region_code": regionCodeValues.reverse[regionCode],
        "region_id": regionId,
        "street": List<dynamic>.from(street.map((x) => x)),
        "telephone": telephone,
      };
}


enum City { CITY }
final cityValues = EnumValues({
  "City": City.CITY,
});

enum CountryId { COUNTRYID }
final countryIdValues = EnumValues({
  "CountryId": CountryId.COUNTRYID,
});

enum Lastname { NAME }
final lastnameValues = EnumValues({
  "name": Lastname.NAME,
});

enum Region { REGION }
final regionValues = EnumValues({
  "Region": Region.REGION,
});

enum RegionCode { REGIONCODE }
final regionCodeValues = EnumValues({
  "Region": RegionCode.REGIONCODE,
});

enum CustomerFirstname { NAME }
final customerFirstnameValues = EnumValues({
  "name": CustomerFirstname.NAME,
});
enum Key { METHOD_TITLE, INSTRUCTIONS }

final keyValues = EnumValues(
    {"instructions": Key.INSTRUCTIONS, "method_title": Key.METHOD_TITLE});

class ShippingAssignments {
  ShippingAssignments({
    this.shipping,
    this.items,
  });

  Shipping shipping;
  List<ParentItemElement> items;

  factory ShippingAssignments.fromJson(Map<String, dynamic> json) =>
      ShippingAssignments(
        shipping: Shipping.fromJson(json["shipping"]),
        items: List<ParentItemElement>.from(
            json["items"].map((x) => ParentItemElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "shipping": shipping.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class ParentItemElement {
  ParentItemElement({
    this.basePrice,
    this.name,
    this.qtyOrdered,
  });

  double basePrice;
  String name;
  int qtyOrdered;

  factory ParentItemElement.fromJson(Map<String, dynamic> json) =>
      ParentItemElement(
        basePrice: Utils.getDouble(json["base_price"]),
        name: json["name"],
        qtyOrdered: json["qty_ordered"],
      );

  Map<String, dynamic> toJson() => {
        "base_price": basePrice,
        "name": name,
        "qty_ordered": qtyOrdered,
      };
}


class Shipping {
  Shipping({
    this.address,
    this.method,
    this.total,
  });

  Addresss address;
  ShippingMethods method;
  Map<String, int> total;

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        address: Addresss.fromJson(json["address"]),
        method: shippingMethodValues.map[json["method"]],
        total:
            Map.from(json["total"]).map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "method": shippingMethodValues.reverse[method],
        "total": Map.from(total).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

enum ShippingMethods { SHIPPINGMETHODS }

final shippingMethodValues =
    EnumValues({"ShippingMethods": ShippingMethods.SHIPPINGMETHODS});

class Payments {
  Payments({
    this.additionalInformation,
  });

  List<String> additionalInformation;

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        additionalInformation:
            List<String>.from(json["additional_information"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "additional_information":
            List<dynamic>.from(additionalInformation.map((x) => x)),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
