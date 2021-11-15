import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:intl/intl.dart" show DateFormat;
import 'package:toast/toast.dart';
import 'package:vismaya/components/checkout/process_order/my_process_order.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/delivery_times/delivery_date.dart';
import 'package:vismaya/models/delivery_times/delivery_slot.dart';
import 'package:vismaya/models/delivery_times/delivery_times.dart';
import 'package:vismaya/models/delivery_times/selected_delivery_time.dart';

import 'my_delivery_times_bloc.dart';

class MyDeliveryTimes extends StatelessWidget {
  final Cart cart;
  SelectedDeliveryTime selectedDeliveryTime = SelectedDeliveryTime();
  TextEditingController _controller = TextEditingController();

  MyDeliveryTimes([this.cart]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select delivery time"),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
          create: (context) => DeliveryTimesBloc()
            ..add(OnLoadDeliveryTimes(selectedDeliveryTime)),
          child: BlocBuilder<DeliveryTimesBloc, DeliveryTimesState>(
              builder: (context, state) {
            if (state is DeliveryTimesLoaded) {
              selectedDeliveryTime = state.selectedDeliveryTime;
              final dates = Iterable<int>.generate(30).map((e) {
                final date = DateTime.now().add(Duration(days: e));
                return DateFormat("yyyy-MM-dd", "en_US").format(date);
              }).toList();

              final _description = state.deliveryTimes.description;
              final _columns = dates
                  .map((date) => DataColumn(
                          label: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(date,
                            style: TextStyle(
                                color: config.brandColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      )))
                  .toList();

              final _rows = state.deliveryTimes.slots
                  .map((slot) => _getDataRow(context, state.deliveryTimes,
                      dates, slot, selectedDeliveryTime))
                  .toList();

              return ListView(
                children: [
                  Visibility(
                    visible: _description.isNotEmpty,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(10),
                      color: Colors.blue[100],
                      child: Text(
                        _description,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          dividerThickness: 0,
                          columnSpacing: 16,
                          columns: _columns,
                          rows: _rows)),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Delivery comment',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: RaisedButton(
                      onPressed: () => _onOrderNowPressed(context, cart),
                      color: config.brandColor,
                      textColor: Colors.white,
                      child: Text("ORDER NOW"),
                    ),
                  )
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          })),
    );
  }

  DataRow _getDataRow(
      BuildContext context,
      DeliveryTimes deliveryTimes,
      List<String> dates,
      DeliverySlot slot,
      SelectedDeliveryTime selectedDeliveryTime) {
    final map = deliveryTimes.deliveryTimesMap;
    final _dataCells = dates.map((date) {
      final deliveryDate = map[date] ?? DeliveryDate();
      final available = deliveryDate.availableDtimeIds.contains(slot.dtimeId);
      final selected = selectedDeliveryTime.date == date &&
          selectedDeliveryTime.dtimeId == slot.dtimeId;
      final backgroundColor = selected ? Colors.green : Colors.transparent;
      final textColor = selected ? Colors.white : Colors.black;
      final cell = available
          ? FlatButton(
              color: backgroundColor,
              onPressed: () => context.bloc<DeliveryTimesBloc>().add(
                  OnDeliveryTimeSelected(
                      SelectedDeliveryTime(date, slot.dtimeId))),
              child: Text(slot.dtime,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  )))
          : Container(
              alignment: Alignment.center,
              color: Colors.grey,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Not available",
                style: TextStyle(color: Colors.white),
              ),
            );
      return DataCell(cell);
    }).toList();
    return DataRow(cells: _dataCells);
  }

  _onOrderNowPressed(BuildContext context, Cart cart) async {
    if (selectedDeliveryTime.date.isEmpty ||
        selectedDeliveryTime.dtimeId.isEmpty) {
      Toast.show("Select delivery date and time", context);
      return;
    }
    selectedDeliveryTime.comment = _controller.text;
    final route = MaterialPageRoute(
        builder: (context) => MyProcessOrder(cart, selectedDeliveryTime));
    final result = await Navigator.push(context, route);
    if (result == null) return;
  }
}
