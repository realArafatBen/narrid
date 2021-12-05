import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/store/checkout/verify_payment_bloc.dart';
import 'package:narrid/dashboard/repositories/store/checkout/verifyPaymentRespo.dart';
import 'package:narrid/dashboard/screens/user/account/orders/orders.dart';

class StoreOrderSuccess extends StatelessWidget {
  final ref;
  StoreOrderSuccess({Key key, this.ref}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VerifyPaymentBloc(verifyPaymentRespo: VerifyPaymentRespo())
            ..add(VerifyStarted(ref)),
      child: MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: BlocBuilder<VerifyPaymentBloc, VerifyPaymentState>(
              builder: (context, state) {
                if (state is VerifyLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is VerifyError) {
                  return buildFailed(context);
                } else if (state is VerifyLoaded) {
                  Map<String, dynamic> data = state.getData;
                  if (data['status'] == 'error') {
                    return buildFailed(context);
                  } else {
                    return Container(
                      child: Center(
                        child: buildSuccess(context),
                      ),
                    );
                  }
                }
              },
            ),
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
          "assets/images/shopping-bag.png",
          width: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "# " + ref.toString(),
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Purchase successful"),
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
                "View Purchase",
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
          "# " + ref.toString(),
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Oops, purchased failed, try again later"),
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
                "View Purchase",
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
