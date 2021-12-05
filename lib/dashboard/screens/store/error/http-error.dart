import 'package:flutter/material.dart';

class HTTPError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/cloud_error.png'),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Try again",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
