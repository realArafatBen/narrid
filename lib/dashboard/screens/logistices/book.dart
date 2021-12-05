import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:narrid/dashboard/bloc/user/auth/authentication_bloc.dart';
import 'package:narrid/dashboard/repositories/user/auth/userRepository.dart';
import 'package:narrid/dashboard/screens/logistices/paystack_logisitces.dart';
import 'package:narrid/dashboard/screens/user/auth/login.dart';

class Book extends StatefulWidget {
  final origin_lat,
      origin_lng,
      origin_address,
      destination_lat,
      destination_lng,
      destination_address,
      distance,
      duration,
      durationvalue,
      distancevalue;

  Book({
    Key key,
    @required this.origin_lat,
    @required this.origin_lng,
    @required this.origin_address,
    @required this.destination_lat,
    @required this.destination_lng,
    @required this.destination_address,
    @required this.distance,
    @required this.duration,
    @required this.distancevalue,
    @required this.durationvalue,
  }) : super(key: key);

  @override
  _BookState createState() => _BookState(
        origin_lat: origin_lat,
        origin_lng: origin_lng,
        origin_address: origin_address,
        destination_lat: destination_lat,
        destination_lng: destination_lng,
        destination_address: destination_address,
        distance: distance,
        duration: duration,
        distancevalue: distancevalue,
        durationvalue: durationvalue,
      );
}

class _BookState extends State<Book> {
  int _radioValue = 0;
  int _paymentValue = 0;
  String real_amount_van = "0.00";
  String real_amount_bike = "0.00";
  String pass_amount = "0.00";
  final origin_lat,
      origin_lng,
      origin_address,
      destination_lat,
      destination_lng,
      destination_address,
      distance,
      duration,
      durationvalue,
      distancevalue;
  _BookState({
    @required this.origin_lat,
    @required this.origin_lng,
    @required this.origin_address,
    @required this.destination_lat,
    @required this.destination_lng,
    @required this.destination_address,
    @required this.distance,
    @required this.duration,
    @required this.durationvalue,
    @required this.distancevalue,
  });
  final _detailsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    //van
    double amount_van = int.parse(distancevalue) / 1000;
    double ex_amount_van = amount_van * 100;
    real_amount_van = ex_amount_van.ceil().toString();
    //bike
    double amount_bike = int.parse(distancevalue) / 1000;
    double ex_amount_bike = amount_bike * 50;
    real_amount_bike = ex_amount_bike.ceil().toString();
    //set default amount to bike
    pass_amount = real_amount_bike;
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          pass_amount = real_amount_bike;
          break;
        case 1:
          pass_amount = real_amount_van;

          break;
        case 2:
          break;
      }
    });
  }

  void _handlePaymentMethodValueChange(int value) {
    setState(() {
      _paymentValue = value;

      switch (_paymentValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Back",
            style: TextStyle(
              color: Colors.grey[900],
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.yellow[800], //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
                create: (context) => AuthenticationBloc(
                    authenticationRepository: UserRepository())
                  ..add(AuthStarted())),
          ],
          child: SingleChildScrollView(
            child: Container(
              child: Column(children: [
                buildAddress(),
                SizedBox(
                  height: 10,
                ),
                buildDeliveryOption(),
                SizedBox(
                  height: 10,
                ),
                buildPaymentMethod(),
                SizedBox(
                  height: 10,
                ),
                buildMoreDetails(),
                SizedBox(
                  height: 10,
                ),
                _buildContineButton(context),
              ]),
            ),
          ),
        ));
  }

  Widget buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Address"),
        ),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 18,
              bottom: 18,
              left: 12,
              right: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pick up Address:"),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.origin_address,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 18,
              bottom: 18,
              left: 12,
              right: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Drop off Address:"),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.destination_address,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDeliveryOption() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Delivery Option"),
          ),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  Icon(
                    Icons.bike_scooter,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text("Bike"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "NGN" + real_amount_bike,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                  ),
                  Icon(
                    Icons.bus_alert,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text("Van"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "NGN" + real_amount_van,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethod() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Payment Method"),
          ),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Radio(
                    value: 0,
                    groupValue: _paymentValue,
                    onChanged: _handlePaymentMethodValueChange,
                  ),
                  Icon(
                    Icons.money,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text("Cash"),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: _paymentValue,
                    onChanged: _handlePaymentMethodValueChange,
                  ),
                  Icon(
                    Icons.credit_card,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text("Card"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMoreDetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'More Details',
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
        controller: _detailsController,
      ),
    );
  }

  Widget _buildContineButton(context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(9),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
              ),
              onPressed: () {
                if (state is AuthenticationUninitialized) {
                } else if (state is AuthenticationAuthenticated) {
                  Map<String, dynamic> data = {
                    'origin_lat': origin_lat,
                    'origin_lng': origin_lng,
                    'origin_address': origin_address,
                    'destination_address': destination_address,
                    'destination_lat': destination_lat,
                    'destination_lng': destination_lng,
                    'details': _detailsController.text,
                    'delivery_option': _radioValue.toString(),
                    'payment_method': _paymentValue.toString(),
                    'amount': pass_amount
                  };
                  Future.delayed(Duration.zero, () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PaytackLogistics(data: data)));
                  });
                } else if (state is AuthenticationUnauthenticated) {
                  Future.delayed(Duration.zero, () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  userRepository: UserRepository(),
                                  route: "logistics",
                                )));
                  });
                }
              },
              child: Text("Book Now"),
            ),
          ),
        );
      },
    );
  }
}
