import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:narrid/dashboard/bloc/store/verifyWallentFunding.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/narrid_app.dart';
import 'package:narrid/dashboard/screens/user/account/wallet/wallet.dart';

class TopUpCompleted extends StatelessWidget {
  final amount, status, ref;
  const TopUpCompleted(
      {@required this.amount, @required this.status, @required this.ref});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) =>
            VerifyWalletPaymentBloc(userRepository: UserRepository())
              ..add(VerifyStarted(ref, amount)),
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                if (status == 'failed') errorInitPayment(context),
                if (status == "success") verifyInitPayment(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget errorInitPayment(context) {
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

  Widget verifyInitPayment(context) {
    return BlocBuilder<VerifyWalletPaymentBloc, VerifyPaymentState>(
      builder: (context, state) {
        if (state is VerifyLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is VerifyError) {
          return errorInitPayment(context);
        } else if (state is VerifyLoaded) {
          Map<String, dynamic> data = state.getData;
          if (data['status'] == 'error') {
            return errorInitPayment(context);
          } else {
            return successPayment(context);
          }
        } else {
          return null;
        }
      },
    );
  }

  Widget successPayment(context) {
    return Container(
      margin: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/icons/success-wallet.svg",
            width: 90,
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
          Text(
            "Congratulation, you have successfully top up NGN${amount} to your wallet",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
                      MaterialPageRoute(builder: (context) => NarridApp()));
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
      ),
    );
  }
}
