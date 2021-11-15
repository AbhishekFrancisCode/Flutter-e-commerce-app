import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vismaya/components/sort/my_sort_list.dart';
import 'package:vismaya/config.dart';

class MySortOptionWidget extends StatefulWidget {
  final List list;

  MySortOptionWidget(this.list);

  @override
  _MySortOptionWidgetState createState() => _MySortOptionWidgetState(this.list);
}

class _MySortOptionWidgetState extends State<MySortOptionWidget> {
  List list;
  _MySortOptionWidgetState(this.list);
  List<SortName> _sortName;
  SortName selectedSortName;
  bool sortc = true;
  @override
  void initState() {
    super.initState();
    _sortName = SortName.getSortName();
  }

  setSelectedSortName(SortName sortName) {
    setState(() {
      selectedSortName = sortName;
      sortc = false;
    });
  }

  List<Widget> createSortList() {
    List<Widget> widgets = [];
    for (SortName sort in _sortName) {
      widgets.add(RadioListTile(
        value: sort,
        groupValue: selectedSortName ,
        title: Text(sort.sortName),
        onChanged: (currentName) {
          setSelectedSortName(currentName);
        },
        activeColor: config.brandColor,
        controlAffinity: ListTileControlAffinity.trailing,
        selected: selectedSortName == sort,
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Column(
        children: createSortList(),
      ),
      SizedBox(height: 300),
      selectedSortName !=null ? Container(
            width: 100,
            child:OutlineButton(
        child: Text("APPLY"),
        onPressed: () {
          //Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MySortList(selectedSortName.sortName, list)));
        },
        borderSide: BorderSide(color: config.brandColor),
        textColor: config.brandColor,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      )):SizedBox(height: 0.1,),
    ]));
  }
}

class SortName {
  bool sortId;
  String sortName;

  SortName({this.sortId, this.sortName});

  static List<SortName> getSortName() {
    return <SortName>[
      SortName(sortId: false, sortName: "Relevance"),
      SortName(sortId: false, sortName: "Sort by Z to A"),
      SortName(sortId: false, sortName: "Sort by Price High to Low"),
      SortName(sortId: false, sortName: "Sort by Price Low to High"),
    ];
  }
}
