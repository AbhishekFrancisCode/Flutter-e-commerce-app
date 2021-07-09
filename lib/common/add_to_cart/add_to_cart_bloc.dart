import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/domain/basket_usecase.dart';
import 'package:vismaya/events/cart_change_event.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/utils/rxbus.dart';

abstract class AddToCartEvent {}

class OnLoadAddToCart extends AddToCartEvent {
  final String sku;
  OnLoadAddToCart(this.sku);
}

class OnAddToCartPressed extends AddToCartEvent {
  final String sku;
  OnAddToCartPressed(this.sku);
}

class OnQuantityChanged extends AddToCartEvent {
  final String sku;
  final int change;
  OnQuantityChanged(this.sku, this.change);
}

//States
abstract class AddToCartState {}

class AddToCartLoading extends AddToCartState {}

class AddToCartLoaded extends AddToCartState {
  int quantity;
  String errorMessage;
  AddToCartLoaded(this.quantity, [this.errorMessage = ""]);
}

class AddToCartError extends AddToCartState {}

//Bloc
class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  String currentSku;
  AddToCartBloc() : super(AddToCartLoading()) {
    RxBus.register<CartChangeEvent>().listen((event) {
      if (event.sku != null && event.sku == currentSku) {
        add(OnLoadAddToCart(currentSku));
      }
    });
  }

  @override
  Stream<AddToCartState> mapEventToState(AddToCartEvent event) async* {
    final currentState = state;
    if (event is OnLoadAddToCart) {
      this.currentSku = event.sku;
      final qty = config.cart.getCartItemBySku(event.sku)?.qty ?? 0;
      yield AddToCartLoaded(qty);
    } else if (event is OnAddToCartPressed) {
      //Add the product to cart
      yield AddToCartLoading();
      try {
        final response = await BasketUsecase.addItemToCart(event.sku);
        config.putCartItem(response.data.sku, response.data);
        yield AddToCartLoaded(response.data.qty);
      } on Failure catch (e) {
        yield AddToCartLoaded(0, e.message);
      }
      RxBus.post(CartChangeEvent());
    } else if (event is OnQuantityChanged) {
      this.currentSku = event.sku;
      //Change the product quantity in the cart
      if (currentState is AddToCartLoaded) {
        yield AddToCartLoading();
        final currentQty = config.cart.getCartItemBySku(event.sku)?.qty ?? 0;
        final qty = currentQty + event.change;
        try {
          if (qty > 0) {
            final response =
                await BasketUsecase.updateItemInCart(event.sku, qty);
            config.putCartItem(response.data.sku, response.data);
          } else {
            await BasketUsecase.deleteItemFromCart(event.sku);
            config.removeCartItem(event.sku);
          }
          yield AddToCartLoaded(qty);
        } on Failure catch (e) {
          yield AddToCartLoaded(currentState.quantity, e.message);
        }
      }
      RxBus.post(CartChangeEvent());
    }
  }
}
