import 'package:narrid/dashboard/models/db/grocery_cart_model.dart';
import 'package:narrid/dashboard/models/food/food_feature_model.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/utils/helpers/grocery_helper.dart';

class GroceryProductRep {
  GroceryHelper helper = GroceryHelper();

  Future<List<ProductsModel>> fetchProducts(id, storeId) async {
    var url = Uri.parse('https://narrid.com/mobile/grocery/products.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'storeId': storeId,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<ProductsModel>((json) => ProductsModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<bool> insert(
    productId,
    productName,
    qty,
    price,
    image,
    shipping_cost,
  ) async {
    // row to insert
    Map<String, dynamic> row = {
      GroceryHelper.columnProductName: productName,
      GroceryHelper.columnQuantity: qty,
      GroceryHelper.columnProductId: productId,
      GroceryHelper.columnPrice: price,
      GroceryHelper.columnImage: image,
      GroceryHelper.columnShippingCost: shipping_cost,
    };
    final id = await helper.insert(row);
    if (id != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> countInCart(id) async {
    final count = await helper.countItem(id);
    if (count == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> quantityCart(_id, qty) async {
    final id = await helper.cartNumberAction(_id, qty);
    if (id != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getItemCart(id) async {
    final cart = await helper.fetchCartId(id);
    return cart;
  }

  Future<bool> removeFromCart(_id) async {
    final id = await helper.delete(_id);
    if (id != 1) {
      return false;
    } else {
      return true;
    }
  }

  //---------------------------------------------------------------------------
  //----------------------------- fetch cart details i.e product image and price

  Future<bool> checkCartStatus() async {
    final id = await helper.queryRowCount();
    if (id == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<GroceryCartHelper>> getProducts() async {
    List<GroceryCartHelper> carts = await getProductCart();
    return carts;
  }

  Future<List<GroceryCartHelper>> getProductCart() async {
    List<GroceryCartHelper> carts = await helper.fetchAllCart();
    return carts;
  }

  Future<List<Map<String, dynamic>>> getProductShipping() async {
    List<Map<String, dynamic>> carts = await helper.queryAllRows();
    return carts;
  }

  Future<void> clearCart() async {
    int id = await helper.removeAllInCart();
    return;
  }

  Future<List<FeatureFoodModel>> getFeatureProducts() async {
    var url =
        Uri.parse('https://narrid.com/mobile/grocery/feature-products.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<FeatureFoodModel>((json) => FeatureFoodModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }
}
