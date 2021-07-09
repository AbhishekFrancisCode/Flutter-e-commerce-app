import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/cart_item.dart';

import 'cart_item_change_qty_button_bloc.dart';

class MyCartItemChangeQtyButton extends StatelessWidget {
  final CartItem cartItem;
  final ValueChanged<int> onQuantityChanged;

  MyCartItemChangeQtyButton(this.cartItem, {this.onQuantityChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartItemChangeQtyBloc(onQuantityChanged)
        ..add(OnLoadChangeQtyCartItem(cartItem)),
      child: BlocBuilder<CartItemChangeQtyBloc, CartItemChangeQtyState>(
          builder: (context, state) {
        if (state is CartItemChangeQtyLoaded) {
          bool canReduce = state.qty > 1;
          return Container(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            child: Wrap(
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  child: FloatingActionButton(
                    elevation: 0,
                    mini: true,
                    heroTag: null,
                    backgroundColor:
                        canReduce ? config.brandColor : Colors.grey,
                    child: Icon(Icons.remove),
                    onPressed: !canReduce
                        ? null
                        : () => context
                            .bloc<CartItemChangeQtyBloc>()
                            .add(OnQtyChangedCartItem(cartItem, -1)),
                  ),
                ),
                Container(
                  width: 40,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    state.qty.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  child: FloatingActionButton(
                    elevation: 0,
                    mini: true,
                    heroTag: null,
                    backgroundColor: config.brandColor,
                    child: Icon(Icons.add),
                    onPressed: () => context
                        .bloc<CartItemChangeQtyBloc>()
                        .add(OnQtyChangedCartItem(cartItem, 1)),
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          width: 100,
          height: 50,
          alignment: Alignment.center,
          child: SizedBox(
              height: 25, width: 25, child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
