import 'package:flutter/material.dart';

class ShowErrorWidget extends StatelessWidget {
  final String message;
  final double height;
  final VoidCallback onPressed;

  ShowErrorWidget(this.message, {this.height, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            message,
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
          ),
          Visibility(
            visible: onPressed != null,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RaisedButton(
                child: Text("Retry"),
                onPressed: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
