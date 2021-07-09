import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/customer.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';

abstract class MyAccountEvent {}

class OnLoadMyAccount extends MyAccountEvent {}

class OnLogOutMyAccount extends MyAccountEvent {}

//States
abstract class MyAccountState {}

class MyAccountLoading extends MyAccountState {}

class MyAccountLoaded extends MyAccountState {
  final Customer customer;
  MyAccountLoaded(this.customer);
}

//Bloc
class MyAccountBloc extends Bloc<MyAccountEvent, MyAccountState> {
  MyAccountBloc() : super(MyAccountLoading());

  @override
  Stream<MyAccountState> mapEventToState(MyAccountEvent event) async* {
    if (event is OnLoadMyAccount) {
      final customer = prefManager.customerInfo;
      yield MyAccountLoaded(customer);
    } else if (event is OnLogOutMyAccount) {
      prefManager.removeCustomerInfo();
      config.clearCart();
      prefManager.setCustomerToken("");
    }
  }
}
