import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vismaya/repositories/local/dao/product_variant_dao.dart';

class DBManager {
  Database _database;
  static final DBManager _singleton = DBManager._internal();
  factory DBManager() => _singleton;
  Future initialized;

  DBManager._internal() {
    initialized = init();
  }

  init() async {
    final path = join(await getDatabasesPath(), kDatabaseName);
    print(path);
    if (_database != null) return;
    _database = await openDatabase(path,
        version: kDatabaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  //Dao
  ProductVariantModelDao getProductVariantModelDao() =>
      ProductVariantModelDao(_database);

  //Create database - Run the CREATE TABLE statement on the database.
  _onCreate(Database db, int version) async {
    await db.execute(PRODUCT_VARIANT_TABLE);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  //DB Constants
  static const String kDatabaseName = "local.db";
  static const int kDatabaseVersion = 1;

  static const String PRODUCT_VARIANT_TABLE = "CREATE TABLE ProductVariant ("
      "sku TEXT PRIMARY KEY,"
      "brandValue TEXT default '',"
      "sizeValue TEXT default '',"
      "status INTEGER default 0"
      ")";
}

DBManager dbManager = DBManager();
