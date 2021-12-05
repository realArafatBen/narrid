import 'package:narrid/dashboard/models/db/cart_db_model.dart';
import 'package:narrid/dashboard/repositories/store/cart_repository.dart';
import 'package:narrid/utils/helpers/checkout_helper.dart';
import 'package:narrid/utils/helpers/database_helper.dart';

class CheckoutCartRepository {
  CheckoutHelper helper = CheckoutHelper();

  Future<bool> insert(productId, productName, qty, variant, variantName,
      variantPrice, image) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnProductName: productName,
      DatabaseHelper.columnQuantity: qty,
      DatabaseHelper.columnVariant: variant,
      DatabaseHelper.columnProductId: productId,
      DatabaseHelper.columnVariantName: variantName,
      DatabaseHelper.columnPrice: variantPrice,
      DatabaseHelper.columnImage: image,
    };
    final id = await helper.insert(row);
    if (id != 0) {
      return true;
    } else {
      return false;
    }
  }

  // insert all
  Future<void> insertAll() async {
    //fetch all from the carts
    CartRepository cartRepository = CartRepository();
    List<CartHelper> carts = await cartRepository.getProducts();
    for (var item in carts) {
      // row to insert
      Map<String, dynamic> row = {
        DatabaseHelper.columnProductName: item.product_name,
        DatabaseHelper.columnQuantity: item.quantity,
        DatabaseHelper.columnVariant: item.variant,
        DatabaseHelper.columnProductId: item.id,
        DatabaseHelper.columnVariantName: item.variantName,
        DatabaseHelper.columnPrice: item.price,
        DatabaseHelper.columnImage: item.image,
      };
      //check if product already exist
      int exist = await helper.countItem(item.id);
      if (exist == 0) {
        final id = await helper.insert(row);
      }
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

  Future<void> clearCartAfterPurchase() async {
    CartRepository cartRepository = CartRepository();

    //remove by product id from the checkout cart
    List<CartHelper> carts = await getProducts();
    for (var item in carts) {
      await cartRepository.removeFromCart(item.id);
    }
    //remove from checkout cart
    await clearCart();
    return;
  }
}
