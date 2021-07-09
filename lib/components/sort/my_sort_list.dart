import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/empty_data_widget.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/product/my_product.dart';
import 'package:vismaya/components/product_list/product_list_item.dart';
import 'package:vismaya/components/sort/my_sort_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/product.dart';
import 'package:vismaya/utils/utils.dart';

class MySortList extends StatelessWidget {
  final String named;
  final List list;
  MySortList(this.named, this.list);
  @override
  Widget build(BuildContext context) {
    String name = named;
    //.replaceAll("[", "").replaceAll("]", "");
    return Scaffold(
      appBar: AppBar(
        title: Text(name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
        create: (context) => SortBloc()..add(OnSort(named, list)),
        child: BlocBuilder<SortBloc, SortState>(builder: (context, state) {
          if (state is SortLoaded) {
            final list = state.list;
            if (list.isEmpty) {
              return EmptyDataWidget("No products found!");
            }
            final count = list.length;
            return ListView.separated(
                itemBuilder: (context, index) {
                  final product = list[index];
                  return ProductListItem(
                    product,
                    index,
                    onTap: () => _onProductClicked(context, product),
                    onVariantPositionChanged: (pos) {
                      context
                          .bloc<SortBloc>()
                          .add(OnVariantPositionChangedSort(index, pos));
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: count);
          } else if (state is SortError) {
            return ShowErrorWidget(
              state.errorMessage,
              onPressed: () =>
                  context.bloc<SortBloc>().add(OnSort(named, list)),
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
    context.bloc<SortBloc>().add(OnRefreshSortProductList());
  }
}
