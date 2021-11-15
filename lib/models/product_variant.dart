import 'package:vismaya/config.dart';
import 'package:vismaya/utils/utils.dart';

class ProductVariant {
  String sku = "";
  String name = "";
  double price = 0;
  List<String> imageUrls = [];
  Map<String, dynamic> customAttributes = Map<String, dynamic>();

  ProductVariant(
      {this.sku = "",
      this.name = "",
      this.price = 0,
      this.imageUrls,
      this.customAttributes});

  String getShortDescription() =>
      customAttributes['short_description'].toString();

  String getDescription() => customAttributes['description'].toString();

  String getThumbnailImageUrl() {
    final imageUrl = customAttributes['thumbnail'].toString();
    return "${config.getProductMediaUrl()}$imageUrl";
  }

  String get sizeValue => customAttributes['size'] ?? "";

  String getSize() => config.getPackSize(sizeValue) ?? "";

  String get brandValue => customAttributes['brand'] ?? "";

  String getBrand() => config.getBrandName(brandValue);

  List get categoryValue => customAttributes['category_ids'] ?? "";

  String getCategory() => config.getCategoryName(categoryValue[0]);

  double getSpecialPrice() {
    final specialPrice = customAttributes['special_price'];
    return Utils.getDouble(specialPrice);
  }

  String getFormattedPrice() => "Rs ${Utils.trucateIfZero(price)}";

  String getFormattedSpecialPrice() =>
      "Rs ${Utils.trucateIfZero(getSpecialPrice())}";

  //From server
  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final mediaGalleryEntries = json['media_gallery_entries'] as List;
    final imageUrls =
        mediaGalleryEntries.map((e) => e['file'].toString()).toList();

    final _customAttributesList = json['custom_attributes'] as List;
      final _customAttributes = Map<String, dynamic>();
    _customAttributesList.forEach((e) {
      final attributeCode = e['attribute_code'];
      final value = e['value'];
      _customAttributes[attributeCode] = value;
    });

    return ProductVariant(
        sku: json['sku'],
        name: json['name'],
        price: double.parse(json['price'].toString()) ?? 0.0,
        imageUrls: imageUrls,
        customAttributes: _customAttributes);
  }
}
