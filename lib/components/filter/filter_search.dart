import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/empty_data_widget.dart';
import 'package:vismaya/common/filter_widget.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/filter/filter_bloc.dart';
import 'package:vismaya/components/product/my_product.dart';
import 'package:vismaya/components/product_list/product_list_item.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/utils/utils.dart';

class MyFilterSearchPage extends StatelessWidget {
  final searchTerm;
  final List<String> brandChecked;
  final List<String> sizeChecked;
  final String categoryChecked;
  final String priceChecked;
  final String categoryName;
  MyFilterSearchPage(this.searchTerm, this.brandChecked, this.sizeChecked,
      this.categoryChecked, this.priceChecked, this.categoryName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(searchTerm, categoryName)),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
        create: (context) => FilterBloc()
          ..add(OnFilter(this.searchTerm, this.brandChecked, this.sizeChecked,
              this.categoryChecked, this.priceChecked)),
        child: BlocBuilder<FilterBloc, FilterState>(builder: (context, state) {
          if (state is FilterLoaded) {
            final list = state.list;
            if (list.isEmpty) {
              return EmptyDataWidget("No products found!");
            }
            final count = list.length;
            String from = "FilterPage";
            var done = 1;
            return Column(children: <Widget>[
              Container(
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10, right: 5),
                  color: Colors.grey[200],
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("$count Items", style: TextStyle(fontSize: 12)),
                        Spacer(),
                        FilterWidget(
                            searchTerm, list, categoryName, from, done),
                      ])),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final product = list[index];
                        return ProductListItem(
                          product,
                          index,
                          onTap: () => _onProductClicked(context, product),
                          onVariantPositionChanged: (pos) {
                            context
                                .bloc<FilterBloc>()
                                .add(OnVariantPositionChanged(index, pos));
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: count))
            ]);
          } else if (state is FilterError) {
            return ShowErrorWidget(
              state.errorMessage,
              onPressed: () => context.bloc<FilterBloc>().add(OnFilter(
                  this.searchTerm,
                  this.brandChecked,
                  this.sizeChecked,
                  this.categoryChecked,
                  this.priceChecked)),
            );
          }
          return ProgressIndicatorWidget();
        }),
      ),
    );
  }

  _onProductClicked(BuildContext context, Product product) async {
    //Navigate to product
    final route = Utils.getRoute(context, MyProductPage(product));
    await Navigator.push(context, route);
    context.bloc<FilterBloc>().add(OnRefreshProductList());
  }
}

_getTitle(searchTerm, categoryName) {
  if (searchTerm is int) {
    return categoryName.toString();
  } else {
    return searchTerm;
  }
}
