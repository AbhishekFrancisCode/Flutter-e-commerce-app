//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/domain/basket_usecase.dart';
import 'package:vismaya/events/cart_change_event.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/utils/rxbus.dart';

abstract class CartEvent {}

class OnLoadCart extends CartEvent {}

class OnCartItemDeleted extends CartEvent {
  final CartItem cartItem;
  final int index;
  OnCartItemDeleted(this.cartItem, this.index);
}

class OnCartItemQtyChanged extends CartEvent {
  final CartItem cartItem;
  final int qty;
  OnCartItemQtyChanged(this.cartItem, this.qty);
}

//States
abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;
  CartLoaded(this.cart);
}

class CartError extends CartState {
  String errorMessage;
  CartError(this.errorMessage);
}

//Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    final _currentState = state;
    if (event is OnLoadCart) {
      try {
        final response = await BasketUsecase.getCartWithDetails();
        final cart = response.data;
        config.cart = cart;
        RxBus.post(CartChangeEvent());
        yield CartLoaded(cart);
        yield* _getCartTotal();
      } on Failure catch (e) {
        yield CartError(e.message);
      }
    } else if (event is OnCartItemDeleted) {
      if (_currentState is CartLoaded) {
        final cart = _currentState.cart;
        cart.items.removeAt(event.index);
        cart.skuCartMap.remove(event.cartItem.sku);
        cart.itemsCount -= 1;
        cart.itemsQty -= event.cartItem.qty;
        config.cart = cart;
        yield CartLoaded(cart);
        RxBus.post(CartChangeEvent(event.cartItem.sku));
        yield* _getCartTotal();
      }
    } else if (event is OnCartItemQtyChanged) {
      if (_currentState is CartLoaded) {
        final cart = _currentState.cart;
        yield CartLoaded(cart);
        yield* _getCartTotal();
      }
    }
  }

  Stream<CartState> _getCartTotal() async* {
    try {
      final response = await BasketUsecase.getCartTotal();
      config.cart.cartTotal = response.data;
      yield CartLoaded(config.cart);
    } on Failure catch (_) {}
  }
}
