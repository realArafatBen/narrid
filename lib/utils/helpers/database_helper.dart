import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "narrid.db";
  static final _databaseVersion = 1;

  static final table = 'cart';

  static final columnId = 'id';
  static final columnProductName = 'product_name';
  static final columnQuantity = 'quantity';
  static final columnVariant = 'variant';
  static final columnVariantName = 'variantName';
  static final columnProductId = 'productId';
  static final columnPrice = 'price';
  static final columnImage = 'image';
  static final columnColor = 'color';
  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE cart(id INTEGER PRIMARY KEY, productId TEXT, product_name TEXT, quantity TEXT, variant TEXT, variantName TEXT, price TEXT, image TEXT, color TEXT)",
    );
    await db.execute(
      "CREATE TABLE grocery_cart(id INTEGER PRIMARY KEY, productId TEXT, product_name TEXT, quantity TEXT, price TEXT, image TEXT, shipping_cost TEXT)",
    );
    await db.execute(
      "CREATE TABLE food_cart(id INTEGER PRIMARY KEY, productId TEXT, product_name TEXT, quantity TEXT, price TEXT, image TEXT, shipping_cost TEXT)",
    );
    await db.execute(
      "CREATE TABLE checkout(id INTEGER PRIMARY KEY, productId TEXT, product_name TEXT, quantity TEXT, variant TEXT, variantName TEXT, price TEXT, image TEXT)",
    );
  }
}
