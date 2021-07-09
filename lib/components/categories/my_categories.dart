import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/search_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/product_list/my_product_list.dart';
import 'package:vismaya/components/search/my_search.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/category.dart';
import 'package:vismaya/utils/utils.dart';

import 'categories_bloc.dart';

class MyCategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: config.brandColor,
        title: Column(
          children: [
            Text("Categories"),
            SizedBox(
              height: 10,
            ),
            SearchWidget(
              title: "Search for products",
              onTextChanged: (searchTerm) {
                Utils.navigateToPage(context, MySearchPage(searchTerm));
              },
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => CategoriesBloc()..add(OnLoadCategories()),
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
            builder: (context, state) {
          if (state is CategoriesLoaded) {
            final categories = state.categories;
            final count = categories.length;
            return ListView.separated(
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final _title = Text(
                    category.name,
                    style: TextStyle(fontSize: 18),
                  );
                  return category.children.isEmpty
                      ? ListTile(
                          title: _title,
                          onTap: () =>
                              _onCategoryTapped(context, category, categories),
                        )
                      : ExpansionTile(
                          title: _title,
                          children: _getChildren(context, category.children),
                        );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: count);
          } else if (state is CategoriesError) {
            return ShowErrorWidget(
              state.errorMessage,
              onPressed: () =>
                  context.bloc<CategoriesBloc>().add(OnLoadCategories()),
            );
          }
          return ProgressIndicatorWidget();
        }),
      ),
    );
  }

  _onCategoryTapped(
      BuildContext context, Category category, List<Category> siblings) async {
    //Navigate to product list
    final route =
        Utils.getRoute(context, MyProductListPage(category, siblings));
    Navigator.push(context, route);
  }

  _getChildren(BuildContext context, List<Category> children) {
    List<Widget> list = [];
    for (Category category in children) {
      final space = "   " * (category.level - 2);
      final _title = Text(
        "$space${category.name}",
        style: TextStyle(fontSize: 18),
      );
      final item = category.children.isEmpty
          ? ListTile(
              title: _title,
              onTap: () => _onCategoryTapped(context, category, children),
            )
          : ExpansionTile(
              title: _title,
              children: _getChildren(context, category.children),
            );
      list.add(item);
    }
    return list;
  }
}
