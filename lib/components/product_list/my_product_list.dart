import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/filter_widget.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/search_widget.dart';
import 'package:vismaya/common/shopping_cart_icon.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/cart/my_cart.dart';
import 'package:vismaya/components/product/my_product.dart';
import 'package:vismaya/components/search/my_search.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/category.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/utils/utils.dart';

import 'product_list_bloc.dart';
import 'product_list_item.dart';

class MyProductListPage extends StatelessWidget {
  final Category category;
  final List<Category> siblings;
  MyProductListPage(this.category, [this.siblings = const []]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(category.name),
          elevation: 0,
          backgroundColor: config.brandColor,
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  //Navigate to cart
                  final route = Utils.getRoute(context, MyCartPage());
                  await Navigator.push(context, route);
                  context.bloc<ProductListBloc>().add(OnRefreshProductList());
                },
                icon: ShoppingCartIcon())
          ]),
      body: Column(
        children: [
          Container(
            color: config.brandColor,
            child: SearchWidget(
              title: "Search for products",
              onTextChanged: (searchTerm) {
                Utils.navigateToPage(context, MySearchPage(searchTerm));
              },
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) =>
                  ProductListBloc()..add(OnLoadProductList(category, siblings)),
              child: BlocBuilder<ProductListBloc, ProductListState>(
                  builder: (context, state) {
                if (state is ProductListLoaded) {
                  final list = state.list;
                  final count = list.length;
                  int id = category.id;
                  String name = category.name;
                  String from = "ProductListPage";
                  var done = 0;
                  return Column(
                    children: <Widget>[
                      Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(left: 10, right: 5),
                          color: Colors.grey[200],
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("$count Items",
                                    style: TextStyle(fontSize: 12)),
                                Spacer(),
                                FilterWidget(id, list, name, from,done),
                              ])),
                      Visibility(
                        visible: siblings.length > 0,
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          color: Colors.grey[200],
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: siblings.length,
                              itemBuilder: (context, index) {
                                final isSelected =
                                    index == state.siblingPosition;
                                return Card(
                                  child: InkWell(
                                    onTap: () =>
                                        _onSiblingClicked(context, index),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 120,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        siblings[index].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: isSelected
                                                ? config.brandColor
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Expanded(
                        child: state.isLoading
                            ? ProgressIndicatorWidget()
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final product = list[index];
                                  return ProductListItem(
                                    product,
                                    index,
                                    onTap: () =>
                                        _onProductClicked(context, product),
                                    onVariantPositionChanged: (pos) {
                                      context.bloc<ProductListBloc>().add(
                                          OnVariantPositionChanged(index, pos));
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: count),
                      ),
                    ],
                  );
                } else if (state is ProductListError) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(category.name),
                      backgroundColor: config.brandColor,
                    ),
                    body: ShowErrorWidget(
                      state.errorMessage,
                      onPressed: () => context
                          .bloc<ProductListBloc>()
                          .add(OnLoadProductList(category, siblings)),
                    ),
                  );
                }
                return ProgressIndicatorWidget();
              }),
            ),
          ),
        ],
      ),
    );
  }

  _onProductClicked(BuildContext context, Product product) async {
    //Navigate to product
    final route = Utils.getRoute(context, MyProductPage(product));
    await Navigator.push(context, route);
    context.bloc<ProductListBloc>().add(OnRefreshProductList());
  }

  _onSiblingClicked(BuildContext context, int index) {
    final _sibling = siblings[index];
    if (_sibling.children.isNotEmpty) {
      final route = Utils.getRoute(
          context, MyProductListPage(_sibling, _sibling.children));
      Navigator.push(context, route);
    } else {
      final categoryId = siblings[index].id;
      context.bloc<ProductListBloc>().add(OnSiblingClicked(index, categoryId));
    }
  }
}
