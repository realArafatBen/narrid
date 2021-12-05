import 'package:url_launcher/url_launcher.dart';

class Global {
  lunchURL(url) async {
    if (!url.contains('http')) url = 'https://$url';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(10000);
  }
}
