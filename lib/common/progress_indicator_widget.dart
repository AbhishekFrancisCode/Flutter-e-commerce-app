import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final String message;
  final double height;

  ProgressIndicatorWidget(
      {this.message = "Loading, please wait...", this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text(message, style: TextStyle(fontSize: 18))
        ],
      ),
    );
  }
}
