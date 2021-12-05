import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:narrid/dashboard/models/store/banner.dart';

class BannersRep {
  Future<List<BannersModel>> getBanners() async {
    /**
     * get the categories from the server
     */
    List<BannersModel> banners = await getBanner();

    //return banner list
    return banners;
  }

  Future<List<BannersModel>> getBanner() async {
    var url = Uri.parse('https://narrid.com/mobile/banner/slider.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();

      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getBannerStore() async {
    var url = Uri.parse('https://narrid.com/mobile/grocery/banner.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();

      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getBannerFood() async {
    var url = Uri.parse('https://narrid.com/mobile/food/banner.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();

      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getAdsBanners() async {
    var url = Uri.parse('https://narrid.com/mobile/banner/ads.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getExclusiveDealsBanners() async {
    var url = Uri.parse('https://narrid.com/mobile/banner/exclusive-deals.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getMegaDealsBanners() async {
    var url = Uri.parse('https://narrid.com/mobile/banner/mega-deals.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getMenFashionBanners() async {
    var url = Uri.parse('https://narrid.com/mobile/banner/men-fashion.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getWomenFashionBanners() async {
    var url = Uri.parse('https://narrid.com/mobile/banner/women-fashion.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();

      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<BannersModel>> getGroceryStoreFashionBanners() async {
    var url = Uri.parse('https://narrid.com/mobile/banner/grocery-store.php');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final returnList = data
          .map<BannersModel>((json) => BannersModel.fromJson(json))
          .toList();
      return returnList;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);

      return error;
    }
  }

  Future<List<dynamic>> getBrandsBanner() async {
    var url = Uri.parse("https://narrid.com/mobile/banner/brands.php");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      List<dynamic> error = jsonDecode(response.reasonPhrase);
      return error;
    }
  }
}
