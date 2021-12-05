import 'package:narrid/dashboard/models/db/grocery_cart_model.dart';
import 'package:narrid/utils/helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class GroceryHelper {
  final instance = DatabaseHelper.instance;

  static final table = 'grocery_cart';

  static final columnId = 'id';
  static final columnProductName = 'product_name';
  static final columnQuantity = 'quantity';
  static final columnProductId = 'productId';
  static final columnPrice = 'price';
  static final columnImage = 'image';
  static final columnShippingCost = 'shipping_cost';

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //fetch row by id
  Future<List<Map<String, dynamic>>> fetchCartId(id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> cart = await db.query(table,
        where: '$columnProductId= ? ', whereArgs: [id], limit: 1);

    return cart;
  }

  //fetch row by id
  Future<List<GroceryCartHelper>> fetchAllCart() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> cart = await db.query(table);

    return List.generate(
        cart.length,
        (index) => GroceryCartHelper(
              id: cart[index]['productId'],
              product_name: cart[index]['product_name'],
              quantity: cart[index]['quantity'],
              price: cart[index]['price'],
              image: cart[index]['image'],
              shipping_cost: cart[index]['shipping_cost'],
            ));
  }

  //check if item exits
  Future<int> countItem(id) async {
    Database db = await instance.database;

    return Sqflite.firstIntValue(await db
        .rawQuery('SELECt COUNT(*) FROM $table WHERE $columnProductId=$id'));
  }

  //update cart
  Future<int> cartNumberAction(id, qty) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      columnQuantity: qty,
    };
    return db.update(table, row, where: '$columnProductId= ?', whereArgs: [id]);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String id) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$columnProductId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> removeAllInCart() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
