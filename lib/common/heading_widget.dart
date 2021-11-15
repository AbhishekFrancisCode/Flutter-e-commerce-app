import 'package:flutter/widgets.dart';

class HeadingWidget extends StatelessWidget {
  final String heading;
  const HeadingWidget(this.heading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        this.heading,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
