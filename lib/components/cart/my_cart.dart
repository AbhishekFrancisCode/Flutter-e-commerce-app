import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/empty_data_widget.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/checkout/address/my_address.dart';
import 'package:vismaya/components/checkout/my_checkout.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/address_type.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';
import 'package:vismaya/utils/utils.dart';

import 'cart_bloc.dart';
import 'cart_sign_in/my_cart_sign_in.dart';
import 'change_quantity/my_cart_item_change_qty_button.dart';
import 'delete_from_cart/my_delete_from_cart_button.dart';

class MyCartPage extends StatelessWidget {
  MyCartPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartBloc()..add(OnLoadCart()),
      child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
        if (state is CartLoaded) {
          final cart = state.cart;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Cart"),
              backgroundColor: config.brandColor,
            ),
            body: cart.itemsCount > 0
                ? Column(
                    children: <Widget>[
                      Container(
                        color: Colors.grey[200],
                        child: ListTile(
                          title: Text("Quantity: ${cart.itemsCount}"),
                          // trailing: FlatButton(
                          //     textColor: config.brandColor,
                          //     onPressed: () {},
                          //     child: Text("Delete all"))
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            separatorBuilder: (context, index) => Divider(),
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                        imageUrl: item.imageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Icon(
                                              Icons.image,
                                              color: Colors.grey[400],
                                              size: 80,
                                            )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            item.brand,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            item.name,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            _getPackSizeAndPrice(item),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              MyCartItemChangeQtyButton(
                                                item,
                                                onQuantityChanged: (qty) =>
                                                    context.bloc<CartBloc>().add(
                                                        OnCartItemQtyChanged(
                                                            item, index)),
                                              ),
                                              MyDeleteFromCartButton(
                                                item,
                                                onItemDeleted: () => context
                                                    .bloc<CartBloc>()
                                                    .add(OnCartItemDeleted(
                                                        item, index)),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  )
                : EmptyDataWidget("No items in your cart!"),
            bottomNavigationBar: cart.itemsCount == 0
                ? null
                : SafeArea(
                    child: Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      dense: true,
                      title: cart.cartTotal.grandTotal > 0
                          ? Text(
                              "Rs ${Utils.trucateIfZero(cart.cartTotal.grandTotal)}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          : null,
                      subtitle: cart.cartTotal.discount == 0
                          ? null
                          : Text(
                              "Rs ${Utils.trucateIfZero(-cart.cartTotal.discount)} saved",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black)),
                      trailing: RaisedButton(
                        color: config.brandColor,
                        textColor: Colors.white,
                        onPressed: () => _handleCheckout(context, state.cart),
                        child: Text("CHECKOUT"),
                      ),
                    ),
                  )),
          );
        } else if (state is CartError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Cart"),
              backgroundColor: config.brandColor,
            ),
            body: ShowErrorWidget(
              state.errorMessage,
              onPressed: () => context.bloc<CartBloc>().add(OnLoadCart()),
            ),
          );
        }
        return Scaffold(
            appBar: AppBar(
              title: Text("Cart"),
              backgroundColor: config.brandColor,
            ),
            body: ProgressIndicatorWidget());
      }),
    );
  }

  _handleCheckout(BuildContext context, Cart cart) async {
    if (config.customerToken.isNotEmpty) {
      //Check if cart has shipping address
      final address = cart.shippingAddress;
      if (address.isEmpty()) {
        if (!config.isGuest) {
          //Prefill firstname and lastname
          final customerInfo = prefManager.customerInfo;
          address.firstname = customerInfo.firstname;
          address.lastname = customerInfo.lastname;
        }
        final addressType = AddressType.SHIPPING;
        final widget = MyAddressPage(address, addressType);
        final route = MaterialPageRoute<Address>(builder: (context) => widget);
        final result = await Navigator.push(context, route);
        if (result == null) return;
        cart.shippingAddress = address;
        cart.billingAddress = address.clone();
      }
      //Navigate to checkout
      Navigator.push(context, Utils.getRoute(context, MyCheckoutPage(cart)));
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SafeArea(
              child: CartSignInWidget(cart),
            );
          });
    }
  }

  String _getPackSizeAndPrice(CartItem item) => item.price > 0
      ? "${item.size} - ${item.formattedPrice()}"
      : "${item.size}";
}
