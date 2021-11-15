import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/domain/basket_usecase.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/repositories/remote/failure.dart';

abstract class CartItemChangeQtyEvent {}

class OnLoadChangeQtyCartItem extends CartItemChangeQtyEvent {
  final CartItem cartItem;
  OnLoadChangeQtyCartItem(this.cartItem);
}

class OnQtyChangedCartItem extends CartItemChangeQtyEvent {
  final CartItem cartItem;
  final int change;
  OnQtyChangedCartItem(this.cartItem, this.change);
}

//States
abstract class CartItemChangeQtyState {}

class ChangeQtyCartItemLoading extends CartItemChangeQtyState {}

class CartItemChangeQtyLoaded extends CartItemChangeQtyState {
  final int qty;
  final bool withError;
  CartItemChangeQtyLoaded(this.qty, [this.withError = false]);
}

//Bloc
class CartItemChangeQtyBloc
    extends Bloc<CartItemChangeQtyEvent, CartItemChangeQtyState> {
  final ValueChanged<int> onQuantityChanged;
  CartItemChangeQtyBloc(this.onQuantityChanged)
      : super(ChangeQtyCartItemLoading());

  @override
  Stream<CartItemChangeQtyState> mapEventToState(
      CartItemChangeQtyEvent event) async* {
    if (event is OnLoadChangeQtyCartItem) {
      yield CartItemChangeQtyLoaded(event.cartItem.qty);
    } else if (event is OnQtyChangedCartItem) {
      yield ChangeQtyCartItemLoading();
      final cartItem = event.cartItem;
      try {
        final qty = cartItem.qty + event.change;
        final response =
            await BasketUsecase.updateItemInCart(event.cartItem.sku, qty);
        cartItem.qty = response.data.qty;
        yield CartItemChangeQtyLoaded(response.data.qty);
        config.putCartItem(response.data.sku, response.data);
        onQuantityChanged(response.data.qty);
      } on Failure catch (_) {
        yield CartItemChangeQtyLoaded(cartItem.qty);
      }
    }
  }
}
