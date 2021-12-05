import 'package:html/parser.dart';

class HtmlString {
  //here goes the function
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}
