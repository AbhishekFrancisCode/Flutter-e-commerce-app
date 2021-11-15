import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/my_orders/my_orders_details/my_orders_detail_bloc.dart';
import 'package:vismaya/components/my_orders/order_cancel/order_cancel.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/utils/utils.dart';
import 'my_orders_detail_bloc.dart';

class MyOrdersDetailsPage extends StatelessWidget {
  final String item;
  MyOrdersDetailsPage(this.item);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
        create: (context) =>
            MyOrdersDetailsBloc()..add(OnLoadMyOrdersDetails(item)),
        child: BlocBuilder<MyOrdersDetailsBloc, MyOrdersDetailsState>(
          builder: (context, state) {
            if (state is MyOrdersDetailsLoaded) {
              final page = state.page;
              return ListView.separated(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: page.items.length,
                  itemBuilder: (context, index) {
                    final item = page.items[index];
                    var date = DateFormat.yMMMMEEEEd().format(item.createdAt);
                    var time = DateFormat("hh:mm a").format(item.createdAt);
                    var payType = item.payment.additionalInformation.toList();
                    return Column(children: <Widget>[
                      ListTile(
                        title: Text(
                          "Order No:  #${item.incrementId}",
                        ),
                        subtitle: Text("Date: $date, $time"),
                      ),
                      Divider(),
                      //status UI
                      _getHeader("SHIPPING STATUS"),
                      Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: config.brandColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: [
                                  Container(
                                      child: Icon(
                                    Icons.fiber_manual_record,
                                    color: Colors.green,
                                  )),
                                  Container(
                                      child: Text("Order Placed",
                                          style: TextStyle(
                                            fontSize: 12,
                                          )))
                                ]),
                                Container(
                                    height: 50,
                                    width: 2,
                                    margin: const EdgeInsets.only(left: 11),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                _getStatusColor(item.status)))),
                                Row(children: [
                                  Container(
                                      child: Icon(Icons.fiber_manual_record,
                                          color: _getStatusColor(item.status))),
                                  Container(
                                      child: Text("${item.status}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: _getStatusColor(
                                                  item.status))))
                                ]),
                                SizedBox(height: 10),
                                Visibility(
                                  visible: item.status == "pending",
                                  child: TextButton(
                                      onPressed: () {
                                        final widget = MyOrdersCancelPage(
                                            item.incrementId,
                                            date,
                                            time,
                                            item.entityId.toString());
                                        Utils.navigateToPage(context, widget);
                                      },
                                      child: Text("Cancel Order",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: config.brandColor))),
                                ),
                              ])),
                      //address details
                      _getHeader("ADDRESS"),
                      Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: config.brandColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5),
                                Text(
                                    "${item.billingAddress.firstname} ${item.billingAddress.lastname}",
                                    style: TextStyle(fontSize: 12)),
                                SizedBox(height: 10),
                                Text("${item.billingAddress.street}",
                                    style: TextStyle(fontSize: 12)),
                                Text(
                                    "${item.billingAddress.city}, ${item.billingAddress.region}",
                                    style: TextStyle(fontSize: 12)),
                                Text("${item.billingAddress.postcode}",
                                    style: TextStyle(fontSize: 12)),
                                SizedBox(height: 5),
                                Row(children: [
                                  Container(
                                      child: Icon(Icons.phone_android_outlined,
                                          size: 15, color: Colors.black)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      child: Text(
                                          "${item.billingAddress.telephone}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black)))
                                ]),
                                SizedBox(height: 5),
                                Row(children: [
                                  Container(
                                      child: Icon(Icons.mail_outline,
                                          size: 15, color: Colors.black)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      child: Text(
                                          "${item.billingAddress.email}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black)))
                                ])
                              ])),
                      //payment details
                      _getHeader("PAYMENT DETAILS"),
                      Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: config.brandColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: Text(
                                          "Subtotal",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Rs ${item.baseSubtotal}",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: Text(
                                          "Shipping & handling",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Rs ${item.baseShippingAmount}",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: Text(
                                          "Tax",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Rs ${item.baseTaxAmount}",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
                                        child: Text(
                                          "Grand Total",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Rs ${item.baseGrandTotal}",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: config.brandColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Text("Payment method:  $payType",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                SizedBox(height: 5),
                              ])),
                      SizedBox(height: 10),
                      //item details
                      Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: config.brandColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                DataTable(
                                  columns: [
                                    DataColumn(label: Text('Item Name')),
                                    DataColumn(label: Text('Quantity')),
                                    DataColumn(label: Text('Price')),
                                  ],
                                  rows: [
                                    for (int i = 0;
                                        i <= item.totalItemCount - 1;
                                        i++)
                                      DataRow(cells: [
                                        DataCell(Container(
                                            width: 150,
                                            child: Text(page
                                                .items[index].items[i].name))),
                                        DataCell(Container(
                                            width: 20,
                                            child: Text(
                                                "x${page.items[index].items[i].qtyOrdered.toString()}"))),
                                        DataCell(Container(
                                            width: 60,
                                            child: Text(
                                                "Rs ${page.items[index].items[i].basePrice}"))),
                                      ]),
                                  ],
                                ),
                              ])),
                    ]);
                  });
            } else if (state is MyOrdersDetailsError) {
              ShowErrorWidget(
                state.errorMessage,
                onPressed: () => context
                    .bloc<MyOrdersDetailsBloc>()
                    .add(OnLoadMyOrdersDetails(item)),
              );
            }
            return ProgressIndicatorWidget();
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    return (status == "pending" || status == "processing")
        ? Colors.deepOrange
        : status == "canceled"
            ? Colors.red
            : status == "complete"
                ? Colors.green
                : Colors.black;
  }

  Widget _getHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 1, left: 8),
      child: Text(title,
          style: TextStyle(fontSize: 14), textAlign: TextAlign.left),
    );
  }
}
