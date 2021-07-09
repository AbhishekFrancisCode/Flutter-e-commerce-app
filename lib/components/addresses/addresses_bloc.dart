//Event
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/customer.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class AddressesEvent {}

class OnLoadAddresses extends AddressesEvent {}

//State
abstract class AddressesState {}

class AddressesLoading extends AddressesState {}

class AddressesLoaded extends AddressesState {
  final Address shipping;
  final Address billing;
  final Customer customerInfo;
  AddressesLoaded(this.shipping, this.billing, this.customerInfo);
}

class AddressesError extends AddressesState {
  final String errorMessage;
  AddressesError(this.errorMessage);
}

//Bloc
class MyAddressesBloc extends Bloc<AddressesEvent, AddressesState> {
  MyAddressesBloc() : super(AddressesLoading());

  @override
  Stream<AddressesState> mapEventToState(AddressesEvent event) async* {
    yield AddressesLoading();
    if (event is OnLoadAddresses) {
      try {
        final response = await RemoteRepository().getCustomerInfo();
        final customerInfo = response.data;
        final addresses = customerInfo.addresses;
        //Set shipping
        Address shipping =
            addresses.firstWhere((e) => e.defaultShipping, orElse: () => null);
        if (shipping == null) {
          shipping = Address();
          shipping.defaultShipping = true;
          customerInfo.addresses.add(shipping);
        }
        shipping.defaultBilling = false;
        shipping.email = shipping.email ?? customerInfo.email;

        //Set billing
        Address billing =
            addresses.firstWhere((e) => e.defaultBilling, orElse: () => null);

        if (billing == null) {
          billing = Address();
          billing.defaultBilling = true;
          customerInfo.addresses.add(billing);
        }
        billing.defaultShipping = false;
        billing.email = billing.email ?? customerInfo.email;

        yield AddressesLoaded(shipping, billing, customerInfo);
      } on Failure catch (e) {
        yield AddressesError(e.message);
      }
    }
  }
}
