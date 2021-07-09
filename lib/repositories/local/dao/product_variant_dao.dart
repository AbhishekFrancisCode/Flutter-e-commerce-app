import 'package:sqflite/sqflite.dart';
import 'package:vismaya/repositories/local/models/product_variant_model.dart';

class ProductVariantModelDao {
  final Database _database;
  static const String kTable = "ProductVariant";

  ProductVariantModelDao(this._database);

  Future<void> insert(ProductVariantModel variant) async {
    return await _database.insert(kTable, variant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ProductVariantModel> getProductVariantModel(String sku) async {
    List<Map> maps = await _database.query(
      kTable,
      where: "sku=?",
      whereArgs: [sku],
    );
    return (maps.length > 0) ? ProductVariantModel.fromMap(maps.first) : null;
  }
}
