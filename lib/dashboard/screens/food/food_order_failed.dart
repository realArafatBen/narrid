import 'package:flutter/material.dart';
import 'package:narrid/dashboard/screens/food/orders.dart';

class FoodOrderFailed extends StatelessWidget {
  final ref;
  FoodOrderFailed({Key key, @required this.ref}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Center(
              child: Column(
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
                              MaterialPageRoute(
                                  builder: (context) => Orders()));
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
