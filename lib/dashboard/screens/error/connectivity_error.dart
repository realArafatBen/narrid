import 'package:flutter/material.dart';
import 'package:narrid/dashboard/screens/error/reconnect.dart';

class ConnectivityError extends StatefulWidget {
  @override
  _ConnectivityErrorState createState() => _ConnectivityErrorState();
}

class _ConnectivityErrorState extends State<ConnectivityError> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: Image.asset(
                    "assets/images/no-connectivity.png",
                    width: 100,
                  ),
                ),
                Reconnect(
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
