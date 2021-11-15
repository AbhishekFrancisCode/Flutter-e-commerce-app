import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/domain/basket_usecase.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/delivery_times/selected_delivery_time.dart';
import 'package:vismaya/models/order_details.dart';
import 'package:vismaya/repositories/remote/failure.dart';

abstract class ProcessOrderEvent {}

class OnLoadProcessOrder extends ProcessOrderEvent {
  final Cart cart;
  final SelectedDeliveryTime selectedDeliveryTime;
  OnLoadProcessOrder(this.cart, this.selectedDeliveryTime);
}

class OnOrderButtonPressed extends ProcessOrderEvent {
  final Cart cart;
  OnOrderButtonPressed(this.cart);
}

//States
abstract class ProcessOrderState {}

class ProcessOrderLoading extends ProcessOrderState {}

class ProcessOrderLoaded extends ProcessOrderState {
  final OrderDetails orderDetails;
  ProcessOrderLoaded(this.orderDetails);
}

class ProcessOrderError extends ProcessOrderState {
  final String message;
  ProcessOrderError(this.message);
}

//Bloc
class OrderButtonBloc extends Bloc<ProcessOrderEvent, ProcessOrderState> {
  OrderButtonBloc() : super(ProcessOrderLoading());

  @override
  Stream<ProcessOrderState> mapEventToState(ProcessOrderEvent event) async* {
    if (event is OnLoadProcessOrder) {
      yield ProcessOrderLoading();
      try {
        //Set delivery times
        final selectedDeliveryTime = event.selectedDeliveryTime;
        selectedDeliveryTime.quoteId = event.cart.items[0].quoteId;
        final deliveryTimesResponse =
            await BasketUsecase.setDeliveryTimes(selectedDeliveryTime);
        //Process order
        final paymentMethod = event.cart.payment.selectedPaymentMethod;
        final response = await BasketUsecase.orderNow(paymentMethod);
        final orderId = response.data;
        yield ProcessOrderLoaded(OrderDetails(orderId: orderId));
        //Clear cart
        config.clearCart();
      } on Failure catch (e) {
        yield ProcessOrderError(e.message);
      }
    }
  }
}
