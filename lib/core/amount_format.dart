import 'package:intl/intl.dart';

class AmountFormat {
  am(amount) {
    //search and replace
    int price = int.parse(amount.replaceAll(".00", ""));
    final formatter = NumberFormat.currency(locale: 'en_US', name: 'NGN');
    return formatter.format(price);
  }
}
