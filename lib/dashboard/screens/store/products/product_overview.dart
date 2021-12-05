import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductOverview extends StatelessWidget {
  final specifications, product_details;
  const ProductOverview({Key key, this.specifications, this.product_details})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        title: Text(
          "Product Overview",
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Product Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 2,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Html(
                    data: product_details,
                    shrinkToFit: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Product specifications",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 2,
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Html(
                    data: specifications,
                    shrinkToFit: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
