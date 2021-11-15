import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'order_cancel_bloc.dart';

class MyOrdersCancelPage extends StatelessWidget {
  final String item;
  final String date;
  final String time;
  final String entityId;
  MyOrdersCancelPage(this.item, this.date, this.time, this.entityId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
          create: (context) =>
              MyOrdersCancelBloc()..add(OnLoadMyOrdersCancel()),
          child: BlocBuilder<MyOrdersCancelBloc, MyOrdersCancelState>(
              builder: (context, state) {
            if (state.cancelOrderSuccess) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(50),
                height: double.infinity,
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Your order has been cancelled successfully",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "",
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
                child: Container(
                    child: ListTile(
                        title: Column(children: <Widget>[
              SizedBox(height: 50),
              Text("Order Cancellation Confirmation",
                  style: TextStyle(fontSize: 25)),
              Divider(
                thickness: 3,
              ),
              SizedBox(height: 15),
              Text("Are you sure to cancel the selected order?",
                  style: TextStyle(fontSize: 15)),
              SizedBox(height: 25),
              Text("Order id: # $item",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              Text("Order placed on: $date  $time",
                  style: TextStyle(fontSize: 13)),
              SizedBox(height: 15),
              state.progress
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      child: CircularProgressIndicator())
                  : Container(
                      child: RaisedButton(
                        onPressed: () => _onCanceledClicked(context),
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: Text("Cancel"),
                      ),
                    )
            ]))));
          })),
    );
  }

  _onCanceledClicked(BuildContext context) {
    final event = OnMyOrdersCancelClicked(entityId);
    context.bloc<MyOrdersCancelBloc>().add(event);
  }
}
