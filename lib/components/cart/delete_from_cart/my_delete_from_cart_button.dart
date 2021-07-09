import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/cart_item.dart';

import 'delete_from_cart_button_bloc.dart';

class MyDeleteFromCartButton extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onItemDeleted;

  MyDeleteFromCartButton(this.cartItem, {this.onItemDeleted});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteCartItemBloc(),
      child: BlocBuilder<DeleteCartItemBloc, DeleteCartItemState>(
          builder: (context, state) {
        if (state is DeleteCartItemLoaded) {
          return IconButton(
              icon: Icon(
                Icons.delete,
                color: config.brandColor,
              ),
              onPressed: () => context
                  .bloc<DeleteCartItemBloc>()
                  .add(OnDeleteCartItemPressed(cartItem, onItemDeleted)));
        }
        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          width: 50,
          height: 50,
          alignment: Alignment.center,
          child: SizedBox(
              height: 25, width: 25, child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
