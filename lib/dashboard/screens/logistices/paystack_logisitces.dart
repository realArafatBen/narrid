import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/logistices/book_bloc.dart';
import 'package:narrid/dashboard/repositories/logistices/book_logistics_repos.dart';
import 'package:narrid/dashboard/screens/logistices/bookFailed.dart';
import 'package:narrid/dashboard/screens/logistices/bookSuccess.dart';
import 'package:narrid/dashboard/screens/logistices/pick-up-drop-off.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaytackLogistics extends StatefulWidget {
  final data;

  PaytackLogistics({@required this.data});

  @override
  _PaytackLogisticsState createState() => _PaytackLogisticsState();
}

class _PaytackLogisticsState extends State<PaytackLogistics> {
  bool isLoading = true;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookBloc(bookRepository: BookRepository())
        ..add(Started(data: widget.data)),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is Error) {
                return buildFailed(context);
              } else if (state is SuccessCard) {
                Map<String, dynamic> data = state.getDataCard;
                var link = data['link'];
                if (data['status'] == 'error') {
                  return buildFailed(context);
                } else {
                  return Stack(
                    children: [
                      WebView(
                        initialUrl: link,
                        javascriptMode: JavascriptMode.unrestricted,
                        userAgent: 'Flutter;Webview',
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          _controller.complete(webViewController);
                        },
                        navigationDelegate: (navigation) {
                          var uri = Uri.dataFromString(navigation.url);
                          var path = uri.path;
                          Map<String, String> params = uri.queryParameters;
                          var trxref = params['trxref'];

                          if (navigation.url ==
                              'https://standard.paystack.co/close') {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BookFailed(ref: trxref)));
                          }
                          if (path == ",https://narrid.com/") {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BookSuccess(ref: trxref)));
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
                    ],
                  );
                }
              } else if (state is SuccessCash) {
                Map<String, dynamic> data = state.getDataCash;
                if (data['status'] == 'error') {
                  return Container(child: Center(child: buildFailed(context)));
                } else {
                  return Container(child: Center(child: buildSuccess(context)));
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildSuccess(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/delivery.png",
          width: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "# Cash Payment",
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Your booking has been received"),
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
                    MaterialPageRoute(builder: (context) => PickUpDropOff()));
              },
              child: Text(
                "Back",
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
          "# Cash Payment",
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
                    MaterialPageRoute(builder: (context) => PickUpDropOff()));
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
