import 'package:flutter/material.dart';

class SwitchTextView extends StatefulWidget {
  final Widget title;
  final bool value;
  final ValueChanged<bool> onValueChanged;
  SwitchTextView({this.value, this.title, this.onValueChanged});

  @override
  State<StatefulWidget> createState() => _SwitchTextView(
      value: value, title: title, onValueChanged: onValueChanged);
}

class _SwitchTextView extends State<SwitchTextView> {
  final Widget title;
  bool value;
  final ValueChanged<bool> onValueChanged;
  _SwitchTextView({this.value, this.title, this.onValueChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        value: value,
        title: title,
        onChanged: (change) {
          setState(() {
            value = change;
          });
          onValueChanged(change);
        });
  }
}
