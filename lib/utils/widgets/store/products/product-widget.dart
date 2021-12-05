import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/screens/store/products/product.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key key,
    @required this.state,
    @required this.context,
  }) : super(key: key);

  final state;
  final context;

  @override
  Widget build(BuildContext context) {
    List<ProductsModel> products = state.getProducts;
    var size = MediaQuery.of(context).size;

    final double itemHeight = size.height;
    final double itemWidth = size.width;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: (itemWidth / itemHeight),
      children: [
        for (var product in products)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Product(
                    id: product.id,
                    product_name: product.name,
                    image: product.image.toString(),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]),
              ),
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  right: 5,
                  left: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                      ),
                      child: Image.network(
                        product.image.toString(),
                        width: 150,
                        height: 150,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 8,
                      ),
                      child: AutoSizeText(
                        product.name.toString(),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        minFontSize: 16,
                        maxFontSize: 16,
                      ),
                    ),
                    Html(
                      data: product.price.toString(),
                      shrinkToFit: true,
                      defaultTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    // Check if it is off
                    product.isOff == 1
                        ? Row(
                            children: [
                              Html(
                                data: "&#8358; ${product.discount}",
                                shrinkToFit: true,
                                defaultTextStyle: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "${product.off} OFF",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Container(),

                    SizedBox(
                      height: 2,
                    ),
                    Flexible(
                      child: AutoSizeText(
                        "Arrives within ${product.extimate}",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        if (product.shipping == 'express')
                          SvgPicture.asset(
                            "assets/images/express.svg",
                            width: 60,
                          ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            Text(
                              "${product.ratings}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              "(${product.orders})",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
