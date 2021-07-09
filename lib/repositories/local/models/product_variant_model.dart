class ProductVariantModel {
  String sku;
  String brandValue;
  String sizeValue;
  ProductVariantModel(this.sku, [this.brandValue = "", this.sizeValue = ""]);

  ProductVariantModel.fromMap(Map<String, dynamic> map) {
    this.sku = map["sku"];
    this.brandValue = map["brandValue"];
    this.sizeValue = map["sizeValue"];
  }

  Map<String, dynamic> toMap() => {
        "sku": sku,
        "brandValue": brandValue,
        "sizeValue": sizeValue,
      };
}
