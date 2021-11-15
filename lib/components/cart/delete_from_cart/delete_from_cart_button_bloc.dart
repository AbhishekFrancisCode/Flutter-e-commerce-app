import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/domain/basket_usecase.dart';
import 'package:vismaya/models/cart_item.dart';
import 'package:vismaya/repositories/remote/failure.dart';

abstract class DeleteCartItemEvent {}

class OnDeleteCartItemPressed extends DeleteCartItemEvent {
  final CartItem cartItem;
  final VoidCallback onItemDeleted;
  OnDeleteCartItemPressed(this.cartItem, this.onItemDeleted);
}

//States
abstract class DeleteCartItemState {}

class DeleteCartItemLoading extends DeleteCartItemState {}

class DeleteCartItemLoaded extends DeleteCartItemState {
  final bool withError;
  DeleteCartItemLoaded([this.withError = false]);
}

//Bloc
class DeleteCartItemBloc
    extends Bloc<DeleteCartItemEvent, DeleteCartItemState> {
  DeleteCartItemBloc() : super(DeleteCartItemLoaded());

  @override
  Stream<DeleteCartItemState> mapEventToState(
      DeleteCartItemEvent event) async* {
    if (event is OnDeleteCartItemPressed) {
      yield DeleteCartItemLoading();
      try {
        await BasketUsecase.deleteItemFromCartByItemId(event.cartItem.itemId);
        config.removeCartItem(event.cartItem.sku);
        event.onItemDeleted();
        yield DeleteCartItemLoaded();
      } on Failure catch (_) {
        yield DeleteCartItemLoaded(true);
      }
    }
  }
}
