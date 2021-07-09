import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/myorders.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';

abstract class MyOrdersEvent {}

class OnLoadMyOrders extends MyOrdersEvent {}

//States
abstract class MyOrdersState {}

class MyOrdersLoading extends MyOrdersState {}

class MyOrdersLoaded extends MyOrdersState {
  final MyOrder list;
  MyOrdersLoaded(this.list);
}

class MyOrdersError extends MyOrdersState {
  final String errorMessage;
  MyOrdersError(this.errorMessage);
}

//Bloc
class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersBloc() : super(MyOrdersLoading());

  @override
  Stream<MyOrdersState> mapEventToState(MyOrdersEvent event) async* {
    if (event is OnLoadMyOrders) {
      yield MyOrdersLoading();
      try {
        var customer = prefManager.customerInfo;
        final response = await RemoteRepository().getMyOrder(customer.email);
        final orders = response.data;
        yield MyOrdersLoaded(orders);
      } on Failure catch (e) {
        yield MyOrdersError(e.message);
      }
    }
  }
}
