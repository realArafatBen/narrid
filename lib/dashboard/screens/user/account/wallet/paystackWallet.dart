import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/top_up_wallet_bloc.dart';
import 'package:narrid/dashboard/repositories/store/checkout/paystackRespo.dart';
import 'package:narrid/dashboard/screens/user/account/wallet/topUpComplete.dart';
import 'package:narrid/dashboard/screens/user/account/wallet/wallet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackWallet extends StatefulWidget {
  final amount;
  PaystackWallet({@required this.amount});

  @override
  _PaystackWalletState createState() => _PaystackWalletState(amount: amount);
}

class _PaystackWalletState extends State<PaystackWallet> {
  bool isLoading = true;
  final amount;
  _PaystackWalletState({@required this.amount});
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopUpWalletBloc(paystackRespo: PaystackRespo())
        ..add(
          TopUpStarted(
            amount: amount,
          ),
        ),
      child: SafeArea(
        child: Scaffold(
          body: _bulidPayment(),
        ),
      ),
    );
  }

  Widget _bulidPayment() {
    return BlocBuilder<TopUpWalletBloc, TopUpWalletState>(
      builder: (context, state) {
        if (state is TopUpWalletLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TopUpWalletFailed) {
          return buildFailed(context);
        } else if (state is TopUpWalletSuccess) {
          Map<String, dynamic> data = state.getData;
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
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  navigationDelegate: (navigation) {
                    var uri = Uri.dataFromString(navigation.url);
                    var path = uri.path;
                    Map<String, String> params = uri.queryParameters;
                    var trxref = params['trxref'];

                    if (navigation.url ==
                        'https://standard.paystack.co/close') {
                      print("Close");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => TopUpCompleted(
                              status: "failed", amount: amount, ref: trxref)));
                    }
                    if (path == ",https://narrid.com/") {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => TopUpCompleted(
                              status: "success", amount: amount, ref: trxref)));
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
        } else {
          return buildFailed(context);
        }
      },
    );
  }

  Widget buildSuccess(BuildContext context) {
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
                    MaterialPageRoute(builder: (context) => Wallet()));
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
                    MaterialPageRoute(builder: (context) => Wallet()));
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
