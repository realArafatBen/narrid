import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:narrid/dashboard/bloc/user/wallet_badge_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/user/account/wallet/paystackWallet.dart';

class Wallet extends StatelessWidget {
  final _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text(
          "Wallet",
          style: TextStyle(color: Colors.grey[800]),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800], //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<WalletBadgeBloc>(
            create: (BuildContext context) =>
                WalletBadgeBloc(userRepos: UserRepository())
                  ..add(
                    WalletBadgeStarted(),
                  ),
          ),
        ],
        child: Container(
          margin: const EdgeInsets.only(
            top: 50,
            left: 10,
            right: 10,
          ),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.wallet,
                      size: 40,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Wallet Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              //Wallet balance
              BlocBuilder<WalletBadgeBloc, WalletBadgeState>(
                builder: (context, state) {
                  if (state is WalletBadgeLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WalletBadgeError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WalletBadgeLoaded) {
                    Map<String, dynamic> data = state.getData;
                    return Center(
                      child: Container(
                        child: Text(
                          "N ${data['balance']}",
                          style: TextStyle(
                            fontSize: 50,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return null;
                  }
                },
              ),
              // Top Input
              Container(
                margin: EdgeInsets.only(
                  top: 40,
                  bottom: 40,
                ),
                child: buildAmountField(),
              ),
              Container(
                child: buildSubmitButton(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAmountField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Top up Amount',
        labelStyle: TextStyle(
          color: Colors.grey[800],
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[900],
          ),
        ),
      ),
      controller: _amountController,
    );
  }

  Widget buildSubmitButton(context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.black,
              ),
            ),
            onPressed: () {
              if (_amountController.text != "") {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => PaystackWallet(
                      amount: _amountController.text,
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Top Up',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
