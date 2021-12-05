import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationActivities {
  Future<List<dynamic>> getPushNotifications() async {
    var url = Uri.parse(
        'https://narrid.com/mobile/activities/get-push-notifications.php');
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
