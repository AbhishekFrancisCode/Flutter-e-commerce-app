import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/heading_widget.dart';
import 'package:vismaya/common/payment_instructions.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/checkout/address/my_address.dart';
import 'package:vismaya/components/delivery_slot/my_delivery_times.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/address_type.dart';
import 'package:vismaya/models/cart.dart';

import 'checkout_bloc.dart';

class MyCheckoutPage extends StatelessWidget {
  final Cart cart;
  MyCheckoutPage(this.cart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.brandColor,
        title: Text("Checkout"),
      ),
      body: BlocProvider(
          create: (context) => CheckoutBloc()..add(OnLoadCheckout(cart)),
          child: BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
            if (state is CheckoutLoaded) {
              final cart = state.cart;
              return ListView(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HeadingWidget("Shipping address"),
                            FlatButton(
                                child: Text(
                                  "Edit",
                                  style: TextStyle(color: config.brandColor),
                                ),
                                onPressed: () => _onEditAddress(
                                    context, AddressType.SHIPPING))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 16),
                          child: Text(cart.shippingAddress.toString(),
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54)),
                        )
                      ]),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HeadingWidget("Billing address"),
                            FlatButton(
                                child: Text(
                                  "Edit",
                                  style: TextStyle(color: config.brandColor),
                                ),
                                onPressed: () => _onEditAddress(
                                    context, AddressType.BILLING))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 16),
                          child: Text(cart.billingAddress.toString(),
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54)),
                        )
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingWidget("Shipping methods"),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: cart.shippingMethods.length,
                            itemBuilder: (context, index) {
                              final method = cart.shippingMethods[index];
                              final _value = method.carrierCode;
                              return RadioListTile<String>(
                                  dense: true,
                                  value: _value,
                                  groupValue:
                                      cart.selectedShippingMethod.carrierCode,
                                  title: Text(
                                    method.methodTitle,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(method.getDisplayTitle(),
                                      style: TextStyle(fontSize: 16)),
                                  onChanged: (value) {
                                    context.bloc<CheckoutBloc>().add(
                                        OnShippingMethodChanged(value, cart));
                                  });
                            })
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeadingWidget("Payment options"),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: cart.payment.paymentMethods.length,
                            itemBuilder: (context, index) {
                              final method = cart.payment.paymentMethods[index];
                              final _value = method.code;
                              return RadioListTile<String>(
                                  dense: true,
                                  value: _value,
                                  groupValue:
                                      cart.payment.selectedPaymentMethod.code,
                                  title: Text(
                                    method.title,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onChanged: (value) {
                                    context.bloc<CheckoutBloc>().add(
                                        OnPaymentMethodChanged(value, cart));
                                  });
                            }),
                        PaymentInstructionsWidget()
                      ]),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: cart.payment.totalSegments.length,
                      itemBuilder: (context, index) {
                        final segment = cart.payment.totalSegments[index];
                        final isLast =
                            index == cart.payment.totalSegments.length - 1;
                        final fontSize = isLast ? 18.0 : 16.0;
                        final fontColor =
                            isLast ? Colors.black : Colors.black54;

                        final textStyle =
                            TextStyle(fontSize: fontSize, color: fontColor);
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  segment.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle,
                                ),
                              ),
                              Text(
                                "Rs ${segment.value}",
                                style: textStyle,
                              )
                            ],
                          ),
                        );
                      }),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: RaisedButton(
                      onPressed: () => _onProceedPressed(context, cart),
                      color: config.brandColor,
                      textColor: Colors.white,
                      child: Text("PROCEED"),
                    ),
                  )
                ],
              );
            } else if (state is CheckoutError) {
              return ShowErrorWidget(
                state.errorMessage,
                onPressed: () =>
                    context.bloc<CheckoutBloc>().add(OnLoadCheckout(cart)),
              );
            }
            return ProgressIndicatorWidget();
          })),
    );
  }

  _onEditAddress(BuildContext context, AddressType addressType) async {
    final address = addressType == AddressType.SHIPPING
        ? cart.shippingAddress
        : cart.billingAddress;
    final widget = MyAddressPage(address, addressType);
    final route = MaterialPageRoute<Address>(builder: (context) => widget);
    final result = await Navigator.push(context, route);
    if (result == null) return;
    if (addressType == AddressType.SHIPPING) {
      cart.shippingAddress = result;
    } else if (addressType == AddressType.BILLING) {
      cart.billingAddress = result;
    }
    context.bloc<CheckoutBloc>().add(OnLoadCheckout(cart));
  }

  _onProceedPressed(BuildContext context, Cart cart) async {
    final route =
        MaterialPageRoute(builder: (context) => MyDeliveryTimes(cart));
    final result = await Navigator.push(context, route);
    if (result == null) return;
  }
}
