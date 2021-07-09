import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:toast/toast.dart';
import 'package:vismaya/common/payment_instructions.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/checkout/process_order/process_order_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/delivery_times/selected_delivery_time.dart';

class MyProcessOrder extends StatelessWidget {
  String orderId = "";
  bool orderInProgress = false;
  final Cart cart;
  final SelectedDeliveryTime selectedDeliveryTime;
  MyProcessOrder(this.cart, this.selectedDeliveryTime);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (orderInProgress) {
          Toast.show("Order in progress...", context);
          return Future.value(false);
        }
        if (orderId.isEmpty) {
          Navigator.of(context).pop();
        } else {
          Phoenix.rebirth(context);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Order"),
          backgroundColor: config.brandColor,
        ),
        body: BlocProvider(
            create: (context) => OrderButtonBloc()
              ..add(OnLoadProcessOrder(cart, selectedDeliveryTime)),
            child: BlocBuilder<OrderButtonBloc, ProcessOrderState>(
                builder: (context, state) {
              orderInProgress = state is ProcessOrderLoading;
              if (state is ProcessOrderLoaded) {
                orderId = state.orderDetails.orderId;
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.green,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Order submitted",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Your orderId: $orderId",
                          style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                          child: Text("Copy order id"),
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(text: orderId));
                            Toast.show("Copied to Clipboard", context);
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      PaymentInstructionsWidget(),
                      SizedBox(
                        height: 10,
                      ),
                      OutlineButton(
                          child: Text(
                            "Continue Shopping",
                            style: TextStyle(
                                fontSize: 18, color: config.brandColor),
                          ),
                          onPressed: () => Phoenix.rebirth(context))
                    ],
                  ),
                );
              } else if (state is ProcessOrderError) {
                return ShowErrorWidget(
                  state.message,
                  onPressed: () => context
                      .bloc<OrderButtonBloc>()
                      .add(OnLoadProcessOrder(cart, selectedDeliveryTime)),
                );
              }
              return ProgressIndicatorWidget(
                  message: "This might take a while, Please be patient...");
            })),
      ),
    );
  }
}
