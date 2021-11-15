import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/myorders.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class MyOrdersDetailsEvent {}

class OnLoadMyOrdersDetails extends MyOrdersDetailsEvent {
  final String item;
  OnLoadMyOrdersDetails(this.item);
}

//States
abstract class MyOrdersDetailsState {}

class MyOrdersDetailsLoading extends MyOrdersDetailsState {}

class MyOrdersDetailsLoaded extends MyOrdersDetailsState {
  final MyOrder page;
  MyOrdersDetailsLoaded(this.page);
}

class MyOrdersDetailsError extends MyOrdersDetailsState {
  String errorMessage;
  MyOrdersDetailsError(this.errorMessage);
}

//Bloc
class MyOrdersDetailsBloc
    extends Bloc<MyOrdersDetailsEvent, MyOrdersDetailsState> {
  MyOrdersDetailsBloc() : super(MyOrdersDetailsLoading());

  @override
  Stream<MyOrdersDetailsState> mapEventToState(
      MyOrdersDetailsEvent event) async* {
    yield MyOrdersDetailsLoading();
    if (event is OnLoadMyOrdersDetails) {
      try {
        final response = await RemoteRepository().getOrdersDetails(event.item);
        final orders = response.data;
        yield MyOrdersDetailsLoaded(orders);
      } on Failure catch (e) {
        yield MyOrdersDetailsError(e.message);
      }
    }
  }
}
