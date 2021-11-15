import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vismaya/components/checkout/address/my_address.dart';
import 'package:vismaya/components/checkout/my_checkout.dart';
import 'package:vismaya/components/login/my_login.dart';
import 'package:vismaya/components/signup/my_signup.dart';
import 'package:vismaya/models/address_type.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/utils/utils.dart';

class CartSignInWidget extends StatelessWidget {
  final Cart cart;
  const CartSignInWidget(this.cart);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 30),
        Container(
          width: 250,
          child: RaisedButton(
            color: Colors.black,
            textColor: Colors.white,
            onPressed: () {
              final route = Utils.getRoute(context, MySignUpPage());
              Navigator.push(context, route);
            },
            child: Text("Create an account"),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 250,
          child: OutlineButton(
            onPressed: () {
              final route = Utils.getRoute(context, MyLogInPage());
              Navigator.push(context, route);
            },
            child: Text("Log in"),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 250,
          child: FlatButton(
              textColor: Colors.blue,
              onPressed: () => _onGuestPressed(context, cart),
              child: Text(
                "Continue as guest",
                style: TextStyle(fontSize: 16),
              )),
        ),
      ],
    );
  }

  _onGuestPressed(BuildContext context, Cart cart) async {
    //Check if cart has shipping address
    final address = cart.shippingAddress;
    if (address.isEmpty()) {
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
  }
}
