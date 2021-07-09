import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/product_list/my_product_list.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/category.dart';
import 'package:vismaya/models/component.dart';
import 'package:vismaya/utils/utils.dart';
import 'package:vismaya/common/search_widget.dart';
import 'package:vismaya/components/search/my_search.dart';

import 'home_bloc.dart';

class MyHomePage extends StatelessWidget {
  final PageController _controller =
      PageController(initialPage: 0, viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: config.brandColor,
        title: Column(
          children: [
            Text(config.brandName),
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
          create: (context) => HomeBloc()..add(OnLoadHome()),
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is HomeLoaded) {
              final list = state.list;
              return ListView.separated(
                padding: const EdgeInsets.only(top: 8),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final component = list[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: component.label.isNotEmpty,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            component.label,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      _getListItem(context, component)
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
              );
            } else if (state is HomeError) {
              return ShowErrorWidget(
                state.errorMessage,
                onPressed: () => context.bloc<HomeBloc>().add(OnLoadHome()),
              );
            }
            return ProgressIndicatorWidget();
          })),
    );
  }

  Widget _getListItem(BuildContext context, Component component) {
    if (component.type == "SLIDER") {
      final list = component.children;
      final itemCount = list.length;
      return Container(
        height: 150,
        child: PageView.builder(
            controller: _controller,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final item = list[index];
              return InkWell(
                onTap: () => _navigateToCategory(context, item.id, item.label),
                child: Container(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.fill,
                      )),
                ),
              );
            }),
      );
    } else if (component.type == "GRID") {
      final list = component.children;
      final itemCount = list.length;
      return GridView.builder(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: itemCount > 4 ? 3 : 2),
          itemBuilder: (context, index) {
            final item = list[index];
            return Container(
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  onTap: () =>
                      _navigateToCategory(context, item.id, item.label),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: item.imageUrl,
                    placeholder: (context, url) => Icon(Icons.image),
                  ),
                ),
              ),
            );
          });
    } else if (component.type == "LIST") {
      final list = component.children;
      final itemCount = list.length;
      final hasLabel = itemCount > 0 && list[0].showLabel;
      final backgroundColor = Utils.getColorFromHex(component.backgroundColor);
      return LimitedBox(
        maxHeight: hasLabel ? 130 : 80,
        child: Container(
          color: backgroundColor,
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final item = list[index];
              return Container(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () =>
                          _navigateToCategory(context, item.id, item.label),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          placeholder: (context, url) => Icon(Icons.image),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: item.showLabel,
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          item.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              width: 10,
            ),
          ),
        ),
      );
    } else if (component.type == "BANNER") {
      final item = component.children[0];
      return Container(
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () => _navigateToCategory(context, item.id, item.label),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            fit: BoxFit.fill,
            placeholder: (context, url) => Icon(Icons.image),
          ),
        ),
      );
    }
    return Container();
  }

  _navigateToCategory(BuildContext context, int id, String name) {
    if (id <= 0) return;
    final category = Category(id: id, name: name);
    final widget = MyProductListPage(category);
    Utils.navigateToPage(context, widget);
  }
}
