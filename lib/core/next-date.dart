import 'package:intl/intl.dart';

class NextDate {
  String date() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    var next_date = DateFormat.MMMd().format(tomorrow);
    return next_date.toString();
  }
}
