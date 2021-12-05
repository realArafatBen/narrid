import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/logistices/verify_payment_logistics_bloc.dart';
import 'package:narrid/dashboard/repositories/logistices/book_logistics_repos.dart';
import 'package:narrid/dashboard/screens/logistices/pick-up-drop-off.dart';

class BookSuccess extends StatelessWidget {
  final ref;
  BookSuccess({Key key, @required this.ref}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VerifyPaymentLogBloc(bookRepository: BookRepository())
            ..add(VerifyStarted(ref)),
      child: MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: BlocBuilder<VerifyPaymentLogBloc, VerifyPaymentState>(
              builder: (context, state) {
                if (state is VerifyLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is VerifyError) {
                  return Container(
                    child: Text("Error"),
                  );
                } else if (state is VerifyLoaded) {
                  Map<String, dynamic> data = state.getData;
                  if (data['status'] == 'error') {
                    return Container(
                      child: Center(
                        child: buildFailed(context),
                      ),
                    );
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
          "assets/images/delivery.png",
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
