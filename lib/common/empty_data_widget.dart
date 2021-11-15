import 'package:flutter/material.dart';

class EmptyDataWidget extends StatelessWidget {
  final String message;

  EmptyDataWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(32),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 20, color: Colors.grey[700], height: 1.5),
          ),
        ));
  }
}
