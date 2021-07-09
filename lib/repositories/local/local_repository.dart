import 'package:vismaya/repositories/local/db_manager.dart';
import 'package:vismaya/repositories/local/models/product_variant_model.dart';

class LocalRepository {
  static final LocalRepository _singleton = LocalRepository._internal();
  factory LocalRepository() => _singleton;
  LocalRepository._internal();

  Future<void> insert(ProductVariantModel variant) =>
      dbManager.getProductVariantModelDao().insert(variant);

  Future<ProductVariantModel> getProductVariantModel(String sku) =>
      dbManager.getProductVariantModelDao().getProductVariantModel(sku);
}

LocalRepository localRepository = LocalRepository();
