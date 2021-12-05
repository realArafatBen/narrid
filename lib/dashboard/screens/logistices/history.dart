import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text(
            "History",
            style: TextStyle(color: Colors.grey[800]),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
            child: Container(
          margin: EdgeInsets.only(
            top: 40,
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/images/logistics/pickup-truck.svg",
                width: 50.0,
              ),
              Text(
                "No Order",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
