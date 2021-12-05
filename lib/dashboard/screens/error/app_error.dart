import 'package:flutter/material.dart';
import 'package:narrid/dashboard/screens/error/reconnect.dart';

class AppError extends StatefulWidget {
  @override
  _AppErrorState createState() => _AppErrorState();
}

class _AppErrorState extends State<AppError> {
  @override
  Widget build(BuildContext context) {
    //set theme value here
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
                    "assets/images/error.png",
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
