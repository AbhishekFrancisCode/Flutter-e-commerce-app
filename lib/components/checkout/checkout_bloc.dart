import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/domain/basket_usecase.dart';
import 'package:vismaya/models/cart.dart';
import 'package:vismaya/models/shipping_billing_request.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';
import 'package:vismaya/repositories/remote/failure.dart';

abstract class CheckoutEvent {}

class OnLoadCheckout extends CheckoutEvent {
  final Cart cart;
  OnLoadCheckout(this.cart);
}

class OnShippingMethodChanged extends CheckoutEvent {
  final String carrierCode;
  final Cart cart;
  OnShippingMethodChanged(this.carrierCode, this.cart);
}

class OnPaymentMethodChanged extends CheckoutEvent {
  final String code;
  final Cart cart;
  OnPaymentMethodChanged(this.code, this.cart);
}

//States
abstract class CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final Cart cart;
  CheckoutLoaded(this.cart);
}

class CheckoutOrderSuccess extends CheckoutState {}

class CheckoutError extends CheckoutState {
  final String errorMessage;
  CheckoutError(this.errorMessage);
}

//Bloc
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  String shippingaddr;
  CheckoutBloc() : super(CheckoutLoading());

  @override
  Stream<CheckoutState> mapEventToState(CheckoutEvent event) async* {
    try {
      if (event is OnLoadCheckout) {
        yield CheckoutLoading();

        final _cart = event.cart;
        final _address = _cart.shippingAddress;
        final response = await BasketUsecase.estimateShippingMethods(_address);
        final shippingMethods = response.data;

        _cart.shippingMethods =
            shippingMethods.where((e) => e.available).toList();
        if (shippingMethods.isNotEmpty &&
            _cart.selectedShippingMethod.carrierCode.isEmpty) {
          _cart.selectedShippingMethod = shippingMethods[0];
        }
        await _initializePaymentMethods(_cart);
        yield CheckoutLoaded(event.cart);
      } else if (event is OnShippingMethodChanged) {
        final _cart = event.cart;
        final _shippingMethod = _cart.shippingMethods.firstWhere(
            (e) => e.carrierCode == event.carrierCode,
            orElse: () => null);
        if (_shippingMethod != null) {
          _cart.selectedShippingMethod = _shippingMethod;
          await _initializePaymentMethods(_cart);
        }
        yield CheckoutLoaded(event.cart);
      } else if (event is OnPaymentMethodChanged) {
        final _cart = event.cart;
        final _paymentMethod = _cart.payment.paymentMethods
            .firstWhere((e) => e.code == event.code);
        if (_paymentMethod != null) {
          _cart.payment.selectedPaymentMethod = _paymentMethod;
        }
        yield CheckoutLoaded(event.cart);
      }
    } on Failure catch (e) {
      yield CheckoutError(e.message);
    }
  }

  Future<void> _initializePaymentMethods(Cart cart) async {
    final _shippingMethod = cart.selectedShippingMethod;
    final customerInfo = prefManager.customerInfo;
    final saveInAddressBook = customerInfo.hasSavedAddresses ? 0 : 1;
    cart.shippingAddress.saveInAddressBook = saveInAddressBook;
    cart.billingAddress.saveInAddressBook = saveInAddressBook;
    final _request = ShippingBillingRequest(
        cart.shippingAddress,
        cart.billingAddress,
        _shippingMethod.carrierCode,
        _shippingMethod.methodCode);
    final _prevSelectedPaymentMethod = cart.payment.selectedPaymentMethod;
    final paymentResponse =
        await BasketUsecase.setShippingAndBillingInfo(_request);
    cart.payment = paymentResponse.data;
    cart.payment.selectedPaymentMethod = _prevSelectedPaymentMethod;
    if (cart.payment.selectedPaymentMethod == null &&
        cart.payment.paymentMethods.isNotEmpty) {
      cart.payment.selectedPaymentMethod = cart.payment.paymentMethods[0];
    }
  }
}
