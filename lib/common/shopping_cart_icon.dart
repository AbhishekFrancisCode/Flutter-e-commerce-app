import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/events/cart_change_event.dart';
import 'package:vismaya/utils/rxbus.dart';

class ShoppingCartIcon extends StatefulWidget {
  @override
  _MyShoppingCartIconState createState() => _MyShoppingCartIconState();
}

class _MyShoppingCartIconState extends State<ShoppingCartIcon> {
  int count = 0;
  @override
  void initState() {
    super.initState();
    registerBus();
  }

  void registerBus() {
    RxBus.register<CartChangeEvent>().listen((event) => setState(() {
          count = config.cart.skuCartMap.length;
        }));
  }

  @override
  Widget build(BuildContext context) {
    count = config.cart.skuCartMap.length;
    Widget badge = Container(
      height: 14,
      width: 14,
      decoration: new BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        minWidth: 14,
        minHeight: 14,
      ),
      child: Center(
        child: new Text(
          '$count',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    return Container(
      height: 30,
      width: 30,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Icon(Icons.shopping_cart),
          Visibility(visible: count > 0, child: badge)
        ],
      ),
    );
  }
}
