import 'package:flutter/material.dart';
import 'package:vismaya/components/filter/my_filter.dart';
import 'package:vismaya/components/sort/sort_option.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/product.dart';

class FilterTab extends StatefulWidget {
  final  searchTerm;
  final List<Product> list;
  final String categoryName;
  final String from;
  FilterTab(this.searchTerm, this.list, this.categoryName, this.from);

  @override
  _FilterTab createState() => _FilterTab(this.searchTerm, this.list, this.categoryName, this.from);
}

class _FilterTab extends State<FilterTab> {
  var searchTerm;
  final List lists;
  String categoryName;
  String from;
  _FilterTab(this.searchTerm, this.lists, this.categoryName, this.from);



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
       length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filters'),
          backgroundColor: config.brandColor,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              SizedBox(
                width: 150,
              child: Tab(text: 'Filter by'),),
              SizedBox(
                width: 150,
              child: Tab(text: 'Sort by'),),
            ],
          ),
          // actions: <Widget>[
          //   FilterTabBrightness(),
          //   FilterTabColor(),
          //   IconButton(
          //     icon: Icon(Icons.help_outline),
          //     onPressed: () => _about(context),
          //   )
          // ],
        ),
        body: TabBarView(
          children: [
            KeepAliveWidget(
              child: MyFilterPage(searchTerm,lists,categoryName,from),
            ),
            KeepAliveWidget(
              child: MySortOptionWidget(lists),
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  KeepAliveWidget({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin<KeepAliveWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}