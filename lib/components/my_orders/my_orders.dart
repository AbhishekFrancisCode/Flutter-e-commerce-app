import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vismaya/common/empty_data_widget.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/components/my_orders/my_orders_bloc.dart';
import 'package:vismaya/models/myorders.dart';
import 'package:vismaya/utils/utils.dart';
import 'my_orders_bloc.dart';
import 'my_orders_details/my_orders_details.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My orders"),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
        create: (context) => MyOrdersBloc()..add(OnLoadMyOrders()),
        child:
            BlocBuilder<MyOrdersBloc, MyOrdersState>(builder: (context, state) {
          if (state is MyOrdersLoaded) {
            final list = state.list;
            List<MyOrderItem> _orderItems = list.items.reversed.toList();
            if (_orderItems.isEmpty) {
              return EmptyDataWidget("You have no Orders!");
            }
            return Column(
              children: <Widget>[
                Container(
                  color: Colors.grey[200],
                  child: ListTile(
                    title: Text("No of Orders: ${state.list.totalCount}"),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: _orderItems.length,
                    itemBuilder: (context, index) {
                      final item = _orderItems[index];
                      var date = DateFormat.yMMMMEEEEd().format(item.createdAt);
                      return GestureDetector(
                          onTap: () {
                            Utils.navigateToPage(
                                context, MyOrdersDetailsPage(item.incrementId));
                          },
                          child: Container(
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: ListTile(
                                leading: CachedNetworkImage(
                                    imageUrl: item.customerEmail,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Icon(
                                          Icons.content_paste,
                                          color: item.status == "pending" ||
                                                  item.status == "processing"
                                              ? config.brandColor
                                              : Colors.grey,
                                          size: 50,
                                        )),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    Row(children: [
                                      Text("Order No:  #${item.incrementId}",
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.right),
                                      SizedBox(width: 45),
                                    ]),
                                    SizedBox(height: 5),
                                    //orderdate
                                    Text("$date",
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.right),
                                    SizedBox(height: 5),
                                    SizedBox(height: 5),
                                    //total price
                                    Text("Rs ${item.baseGrandTotal}",
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.right),
                                    SizedBox(height: 5),
                                    //item count
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12),
                                            child: Text(
                                              "${item.totalItemCount} items",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${item.status}",
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: item.status == "pending" ||
                                                      item.status ==
                                                          "canceled" ||
                                                      item.status ==
                                                          "processing"
                                                  ? config.brandColor
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              )));
                    },
                  ),
                ),
              ],
            );
          } else if (state is MyOrdersError) {
            return ShowErrorWidget(
              state.errorMessage,
              onPressed: () =>
                  context.bloc<MyOrdersBloc>().add(OnLoadMyOrders()),
            );
          }
          return ProgressIndicatorWidget();
        }),
      ),
    );
  }
}
