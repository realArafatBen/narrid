import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
}
