import 'package:narrid/dashboard/models/db/food_cart_model.dart';
import 'package:narrid/dashboard/models/food/food_feature_model.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:http/http.dart' as http;
import 'package:narrid/utils/helpers/food_cart_helper.dart';
import 'dart:convert';

class FoodProductRep {
  FoodHelper helper = FoodHelper();

  Future<List<ProductsModel>> fetchProducts(id, storeId) async {
    var url = Uri.parse('https://narrid.com/mobile/food/products.php');
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
      FoodHelper.columnProductName: productName,
      FoodHelper.columnQuantity: qty,
      FoodHelper.columnProductId: productId,
      FoodHelper.columnPrice: price,
      FoodHelper.columnImage: image,
      FoodHelper.columnShippingCost: shipping_cost,
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

  Future<List<FoodCartHelper>> getProducts() async {
    List<FoodCartHelper> carts = await getProductCart();
    return carts;
  }

  Future<List<FoodCartHelper>> getProductCart() async {
    List<FoodCartHelper> carts = await helper.fetchAllCart();
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
    var url = Uri.parse('https://narrid.com/mobile/food/feature-products.php');
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
