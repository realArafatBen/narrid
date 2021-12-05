import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/repositories/store/checkout_cart_repository.dart';
import 'package:narrid/utils/helpers/database_helper.dart';
import 'package:narrid/utils/helpers/store_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartRepository {
  StoreHelper helper = StoreHelper();

  Future<bool> insert(productId, productName, qty, variant, variantName,
      variantPrice, image, color) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductName: productName,
      DatabaseHelper.columnQuantity: qty,
      DatabaseHelper.columnVariant: variant,
      DatabaseHelper.columnProductId: productId,
      DatabaseHelper.columnVariantName: variantName,
      DatabaseHelper.columnPrice: variantPrice,
      DatabaseHelper.columnImage: image,
      DatabaseHelper.columnColor: color,
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

  Future<List<CartHelper>> getItemCart(id) async {
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

  Future<List<CartHelper>> getProducts() async {
    List<CartHelper> carts = await getProductCart();
    return carts;
  }

  Future<List<CartHelper>> getProductCart() async {
    List<CartHelper> carts = await helper.fetchAllCart();
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

  //Checkout chart

  Future<void> clearCheckoutCart() async {
    int id = await helper.removeAllInCart();
    return;
  }

  Future<void> removeSelected() async {
    CheckoutCartRepository checkoutCartRepository = CheckoutCartRepository();
    List<CartHelper> carts = await checkoutCartRepository.getProducts();
    for (var item in carts) {
      await helper.delete(item.id);
    }
    //clear the checkout cart items
    await checkoutCartRepository.clearCart();
    return;
  }

  Future<Map<String, dynamic>> getProductDetails(id) async {
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var url = Uri.parse('https://narrid.com/mobile/cart/product-details.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'city': '$city',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      Map<String, dynamic> error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }
}
