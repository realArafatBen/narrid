import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:narrid/dashboard/models/store/products/products-model.dart';
import 'package:narrid/dashboard/screens/store/products/product.dart';

class ProductWidgetX extends StatelessWidget {
  const ProductWidgetX({
    Key key,
    @required this.state,
    @required this.context,
  }) : super(key: key);

  final state;
  final context;

  @override
  Widget build(BuildContext context) {
    List<ProductsModel> products = state.getProducts;
    return ListView(
      scrollDirection: Axis.horizontal,
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
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]),
              ),
              margin: const EdgeInsets.all(5),
              constraints: BoxConstraints(
                minWidth: 150,
                maxWidth: 150,
              ),
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 8,
                    right: 8,
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
                          width: 140,
                          height: 140,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Container(
                        child: AutoSizeText(
                          product.name.toString(),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      Html(
                        data: product.price.toString(),
                        shrinkToFit: true,
                        defaultTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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
                        height: 10,
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
                        height: 20,
                      ),
                      Row(
                        children: [
                          if (product.shipping == 'express')
                            SvgPicture.asset(
                              "assets/images/express.svg",
                              width: 50,
                            ),
                          SizedBox(
                            width: 2,
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
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                "(${product.orders})",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          ),
      ],
    );
  }
}
