import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_select/smart_select.dart';
import 'package:vismaya/components/filter/filter_search.dart';
import 'package:vismaya/components/filter/filter_tab.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/product.dart';

List<String> _brandChecked = [];
List<String> _sizeChecked = [];
var _categoryChecked;
var _priceChecked;

class MyFilterPage extends StatefulWidget {
  final searchTerm;
  final List<Product> list;
  final String categoryName;
  final String from;
  MyFilterPage(this.searchTerm, this.list, this.categoryName, this.from);

  @override
  _MyFilterPage createState() =>
      _MyFilterPage(this.searchTerm, this.list, this.categoryName, this.from);
}

class _MyFilterPage extends State<MyFilterPage> {
  var searchTerm;
  final List lists;
  String categoryName;
  String from;
  _MyFilterPage(this.searchTerm, this.lists, this.categoryName, this.from);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
      SmartSelect<String>.multiple(
        title: 'Brand',
        choiceItems: S2Choice.listFrom<String, Map<String, dynamic>>(
          source: _filtererBrand(lists),
          value: (index, item) => item['bid'],
          title: (index, item) => item['bname'],
        ),
        placeholder: null,
        onChange: (selected) {
          setState(() => _brandChecked = selected.value);
        },
        modalDividerBuilder: (context, state) {
          return Divider();
        },
        modalFooterBuilder: (context, state) {
          return Container(
              padding: EdgeInsets.only(right: 10, bottom: 5),
              alignment: Alignment.centerRight,
              child: Text('selected ${state.changes.length}'));
        },
        modalType: S2ModalType.bottomSheet,
        choiceStyle: S2ChoiceStyle(
            color: config.brandColor, activeColor: config.brandColor),
        modalFilter: true,
        modalFilterAuto: true,
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            isTwoLine: true,
          );
        },
      ),
      Divider(indent: 20),
      SmartSelect<String>.multiple(
        title: 'Size',
        choiceItems: S2Choice.listFrom<String, Map<String, dynamic>>(
          source: _filtererSize(lists),
          value: (index, item) => item['sid'],
          title: (index, item) => item['sname'],
        ),
        placeholder: null,
        onChange: (selected) {
          setState(() => _sizeChecked = selected.value);
        },
        modalDividerBuilder: (context, state) {
          return Divider();
        },
        modalFooterBuilder: (context, state) {
          return Container(
              padding: EdgeInsets.only(right: 10, bottom: 5),
              alignment: Alignment.centerRight,
              child: Text('selected ${state.changes.length}'));
        },
        choiceStyle: S2ChoiceStyle(
            color: config.brandColor, activeColor: config.brandColor),
        modalType: S2ModalType.bottomSheet,
        modalFilter: true,
        modalFilterAuto: true,
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            isTwoLine: true,
          );
        },
      ),
      from == "FilterPage"
          ? Divider(
              indent: 20,
            )
          : SizedBox(height: 0.1),
      from == "FilterPage"
          ? SmartSelect<String>.single(
              title: 'Category',
              choiceItems: S2Choice.listFrom<String, Map<String, dynamic>>(
                  source: _filtererCategory(lists),
                  value: (index, item) => item['cid'],
                  title: (index, item) => item['cname']),
              onChange: (selected) {
                setState(() => _categoryChecked = selected.value);
              },
              placeholder: null,
              choiceStyle: S2ChoiceStyle(
                  color: config.brandColor, activeColor: config.brandColor),
              modalType: S2ModalType.bottomSheet,
              modalFilter: true,
              modalFilterAuto: true,
              tileBuilder: (context, state) {
                return S2Tile.fromState(
                  state,
                  isTwoLine: true,
                );
              },
            )
          : SizedBox(
              height: 0.1,
            ),
      Divider(indent: 20),
      SmartSelect<String>.single(
        title: 'Price',
        choiceItems: S2Choice.listFrom<String, Map<String, dynamic>>(
            source: _filtererPrice(),
            value: (index, item) => item['pid'],
            title: (index, item) => item['pname']),
        placeholder: null,
        onChange: (selected) {
          setState(() => _priceChecked = selected.value);
        },
        choiceStyle: S2ChoiceStyle(
            color: config.brandColor, activeColor: config.brandColor),
        modalType: S2ModalType.bottomSheet,
        tileBuilder: (context, state) {
          return S2Tile.fromState(
            state,
            isTwoLine: true,
          );
        },
      ),
      Divider(indent: 20),
      from == "FilterPage"
          ? SizedBox(height: 200)
          : SizedBox(
              height: 270,
            ),
      Row(
        children: [
          SizedBox(width: 100),
          Container(
              width: 100,
              child: OutlineButton(
                child: Text("CLEAR ALL"),
                onPressed: () {
                  if (_brandChecked.isEmpty == false ||
                      _sizeChecked.isEmpty == false ||
                      _categoryChecked != null ||
                      _priceChecked != null) {
                    _brandChecked.clear();
                    _sizeChecked.clear();
                    _categoryChecked = null;
                    _priceChecked = null;
                    Navigator.pop(context); // pop current page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FilterTab(
                                searchTerm, lists, categoryName, from)));
                  }
                },
                color: Colors.white,
                textColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              )),
          SizedBox(width: 20),
          Container(
              width: 100,
              child: OutlineButton(
                child: Text("APPLY"),
                onPressed: () {
                  if (_brandChecked.isEmpty == false ||
                      _sizeChecked.isEmpty == false ||
                      _categoryChecked != null ||
                      _priceChecked != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyFilterSearchPage(
                                searchTerm,
                                _brandChecked,
                                _sizeChecked,
                                _categoryChecked,
                                _priceChecked,
                                categoryName)));
                  }
                },
                borderSide: BorderSide(color: config.brandColor),
                textColor: config.brandColor,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ))
        ],
      ),
    ])));
  }
}

_filtererBrand(List lists) {
  List _toCompare = [];
  List<Map<String, dynamic>> _filterList = [];
  for (int i = 0; i < lists.length; i++) {
    final item0 = lists[i].getBrand();
    final item1 = lists[i].getBrandId();
    if (!_toCompare.contains(item0)) {
      _filterList.add({
        'bname': item0,
        'bid': item1,
      });
      _toCompare.add(item0);
    }
    return _filterList;
  }
}

_filtererSize(List lists) {
  List _toCompare = [];
  List<Map<String, dynamic>> _filterList = [];
  for (int i = 0; i < lists.length; i++) {
    final item2 = lists[i].getSize();
    final item3 = lists[i].getSizeId();
    if ((!_toCompare.contains(item2))) {
      _filterList.add({
        'sname': item2,
        'sid': item3,
      });
    }
    _toCompare.add(item2);
  }
  return _filterList;
}

_filtererCategory(List lists) {
  List _toCompare = [];
  List<Map<String, dynamic>> _filterList = [];
  _filterList.add({
    'cname': 'None',
    'cid': '0',
  });
  for (int i = 0; i < lists.length; i++) {
    final item4 = lists[i].getCategory();
    final item5 = lists[i].getCategoryId();
    if ((!_toCompare.contains(item4))) {
      _filterList.add({
        'cname': item4,
        'cid': item5,
      });
    }
    _toCompare.add(item4);
  }
  return _filterList;
}

_filtererPrice() {
  List<Map<String, dynamic>> _filterList = [
    {'pname': "All range", 'pid': '10000'},
    {'pname': "Less than \u{20B9} 20", 'pid': '20'},
    {'pname': "\u{20B9}21 to \u{20B9} 50", 'pid': '50'},
    {'pname': "\u{20B9}51 to \u{20B9} 100", 'pid': '100'},
    {'pname': "\u{20B9}101 to \u{20B9} 200", 'pid': '200'},
    {'pname': "\u{20B9}201 to \u{20B9} 500", 'pid': '500'},
    {'pname': "More than \u{20B9} 501", 'pid': '501'}
  ];
  return _filterList;
}
