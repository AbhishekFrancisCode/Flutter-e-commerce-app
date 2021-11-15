import 'package:vismaya/config.dart';
import 'package:vismaya/models/product_variant.dart';

class Product {
  String name = "";
  int variantPosition = 0;
  List<ProductVariant> variants = [];

  Product({this.name = ""});

  String getDescription() {
    return getCurrentVariant().customAttributes['description'].toString();
  }

  String getImageUrl() {
    final imageUrl = getCurrentVariant().customAttributes['image'].toString();
    return "${config.getProductMediaUrl()}$imageUrl";
  }

  String getThumbnailImageUrl() {
    final imageUrl =
        getCurrentVariant().customAttributes['thumbnail'].toString();
    return "${config.getProductMediaUrl()}$imageUrl";
  }

  String getSize() {
    final size = getCurrentVariant().customAttributes['size'];
    return config.getPackSize(size) ?? "";
  }

  String getSizeId() {
    final size = getCurrentVariant().customAttributes['size'];
    return size;
  }

  String getGroupName() => "${getBrand()}-$name";

  double getPrice() => getCurrentVariant().price;

  double getSpecialPrice() => getCurrentVariant().getSpecialPrice();

  String getFormattedPrice() => getCurrentVariant().getFormattedPrice();

  String getFormattedSpecialPrice() =>
      getCurrentVariant().getFormattedSpecialPrice();

  String getBrand() {
    final brand = getCurrentVariant().customAttributes['brand'];
    print(brand);
    return config.getBrandName(brand);
  }

  String getBrandId() {
    final brand = getCurrentVariant().customAttributes['brand'];
    return brand;
  }

  String getCategory() {
    var category = getCurrentVariant().customAttributes['category_ids'];
    var a = category[0].toString();
    return config.getCategoryName(a);
  }

    String getCategorizes(String b) {
    var category = getCurrentVariant().customAttributes['category_ids'];
    var a = category[0].toString();
    return config.getCategoryName(a);
  }

  String getCategoryId() {
    final category = getCurrentVariant().customAttributes['category_ids'];
    return category[0].toString();
  }

  ProductVariant getCurrentVariant() => variants[variantPosition];
}
