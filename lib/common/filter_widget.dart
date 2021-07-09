import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vismaya/components/filter/filter_tab.dart';
import 'package:vismaya/models/product.dart';

class FilterWidget extends StatefulWidget {
  final searchTerm;
  final List<Product> list;
  final categoryName;
  final from;
  final done;
  FilterWidget(
      this.searchTerm, this.list, this.categoryName, this.from, this.done);

  @override
  _FilterWidgetState createState() => _FilterWidgetState(
      this.searchTerm, this.list, this.categoryName, this.from, this.done);
}

class _FilterWidgetState extends State<FilterWidget> {
  var searchTerm;
  List<Product> list;
  String categoryName;
  String from;
  var done;
  _FilterWidgetState(
      this.searchTerm, this.list, this.categoryName, this.from, this.done);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            width: 70,
            child: FlatButton(
              color: done == 0 ? Colors.white : Colors.grey[800],
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        FilterTab(searchTerm, list, categoryName, from)));
              },
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
              
              side:BorderSide(color: done == 0 ? Colors.white : Colors.grey[800],)),
              padding: EdgeInsets.all(0.0),
              child: done == 0 ? Image.asset('assets/icon/filter/filter_icon white2.png'):
              Image.asset('assets/icon/filter/filter_icon black2.png'),
            )));
  }
}
