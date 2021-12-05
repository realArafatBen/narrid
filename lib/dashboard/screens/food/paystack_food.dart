import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/food/products/paystack_checkout_food_bloc.dart';
import 'package:narrid/dashboard/repositories/food/products/paystack_food_repos.dart';
import 'package:narrid/dashboard/screens/food/food_order_failed.dart';
import 'package:narrid/dashboard/screens/food/food_order_success.dart';
import 'package:narrid/dashboard/screens/food/orders.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackFood extends StatefulWidget {
  final shipping, subTotal, total;
  PaystackFood(
      {Key key,
      @required this.shipping,
      @required this.subTotal,
      @required this.total})
      : super(key: key);

  @override
  _PaystackFoodState createState() => _PaystackFoodState();
}

class _PaystackFoodState extends State<PaystackFood> {
  bool isLoading = true;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PaystackCheckoutFoodBloc(paystackFoodRespo: PaystackFoodRespo())
            ..add(PaystackStarted(
                widget.shipping.toString(), widget.subTotal.toString())),
      child: SafeArea(
        child: Scaffold(
          body: _buildBlocBuilder(),
        ),
      ),
    );
  }

  Widget _buildBlocBuilder() {
    return BlocBuilder<PaystackCheckoutFoodBloc, PaystackCheckoutState>(
      builder: (context, state) {
        if (state is PaystackLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PaystackError) {
          return buildFailed(context);
        } else if (state is PaystackLoaded) {
          Map<String, dynamic> data = state.getData;
          var link = data['link'];
          if (data['status'] == 'error') {
            return buildFailed(context);
          } else {
            return Stack(children: [
              WebView(
                initialUrl: link,
                javascriptMode: JavascriptMode.unrestricted,
                userAgent: 'Flutter;Webview',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                navigationDelegate: (navigation) {
                  var uri = Uri.dataFromString(navigation.url);
                  var path = uri.path;
                  Map<String, String> params = uri.queryParameters;
                  var trxref = params['trxref'];

                  if (navigation.url == 'https://standard.paystack.co/close') {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FoodOrderFailed(ref: trxref)));
                  }
                  if (path == ",https://narrid.com/") {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => FoodOrderSuccess(ref: trxref)));
                  }
                  return NavigationDecision.navigate;
                },
                onPageFinished: (finish) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(),
            ]);
          }
        }
      },
    );
  }

  Widget buildFailed(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/warning.png",
          width: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "",
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Oops, there was an error, try again later"),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Orders()));
              },
              child: Text(
                "Try again",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
