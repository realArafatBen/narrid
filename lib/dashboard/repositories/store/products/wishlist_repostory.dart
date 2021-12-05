import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/repositories/map/location_repos.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';

class WishListRepository {
  Future<bool> addToWishList(id) async {
    UserRepository userRepository = UserRepository();
    var userId = await userRepository.getUserId();
    var url = Uri.parse('https://narrid.com/mobile/wishlist/add.php');
    var response =
        await http.post(url, body: {'id': '$id', 'userId': '$userId'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      jsonDecode(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> checkWishListStatus(id) async {
    UserRepository userRepository = UserRepository();
    var userId = await userRepository.getUserId();

    //check if auth
    bool auth = await userRepository.hasToken();
    if (auth) {
      var url = Uri.parse('https://narrid.com/mobile/wishlist/check.php');
      var response =
          await http.post(url, body: {'id': '$id', 'userId': '$userId'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return true;
        } else {
          return false;
        }
      } else {
        jsonDecode(response.reasonPhrase);
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> removeFromWishList(id) async {
    UserRepository userRepository = UserRepository();
    var userId = await userRepository.getUserId();
    var url = Uri.parse('https://narrid.com/mobile/wishlist/remove.php');
    var response =
        await http.post(url, body: {'id': '$id', 'userId': '$userId'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      jsonDecode(response.reasonPhrase);
      return false;
    }
  }

  Future<List<ProductsModel>> fetchWishList() async {
    UserRepository userRepository = UserRepository();
    LocationRespos locationRespos = new LocationRespos();
    String city = await locationRespos.getLocationForProduct();
    var id = await userRepository.getUserId();
    var url = Uri.parse('https://narrid.com/mobile/users/account/wishlist.php');
    var response = await http.post(url, body: {
      'id': '$id',
      'city': '$city',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<ProductsModel>((json) => ProductsModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      final error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }
}
