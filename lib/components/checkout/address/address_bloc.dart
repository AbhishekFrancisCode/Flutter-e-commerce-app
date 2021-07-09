import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/address_type.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';

abstract class AddressEvent {}

class OnLoadAddress extends AddressEvent {
  final AddressType addressType;
  final Address address;
  OnLoadAddress(this.addressType, this.address);
}

//States
abstract class AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final Address address;
  AddressLoaded(this.address);
}

//Bloc
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressLoading());

  @override
  Stream<AddressState> mapEventToState(AddressEvent event) async* {
    if (event is OnLoadAddress) {
      final address = event.address;
      if (address.isEmpty() &&
          !config.isGuest &&
          event.addressType != AddressType.OTHER_ADDRESS) {
        //Prefill firstname and lastname
        final customerInfo = prefManager.customerInfo;
        address.firstname = customerInfo.firstname;
        address.lastname = customerInfo.lastname;
      }
      yield AddressLoaded(event.address);
    }
  }
}
