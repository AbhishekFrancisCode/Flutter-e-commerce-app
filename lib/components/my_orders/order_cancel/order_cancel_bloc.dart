import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class MyOrdersCancelEvent {}

class OnLoadMyOrdersCancel extends MyOrdersCancelEvent {}

class OnMyOrdersCancelClicked extends MyOrdersCancelEvent {
  String entityId;
  OnMyOrdersCancelClicked(this.entityId);
}

//States
abstract class MyOrdersCancelState {
  bool progress = false;
  bool cancelOrderSuccess = false;
  String errorMessage = "";
  MyOrdersCancelState();
}

class MyOrdersCancelLoaded extends MyOrdersCancelState {}

//Bloc
class MyOrdersCancelBloc
    extends Bloc<MyOrdersCancelEvent, MyOrdersCancelState> {
  MyOrdersCancelBloc() : super(MyOrdersCancelLoaded());

  @override
  Stream<MyOrdersCancelState> mapEventToState(
      MyOrdersCancelEvent event) async* {
    if (event is OnLoadMyOrdersCancel) {
      yield MyOrdersCancelLoaded();
    } else if (event is OnMyOrdersCancelClicked) {
      yield MyOrdersCancelLoaded()..progress = true;
      bool _isCancelOrderSuccess = false;
      String _errorMessage = "";
      try {
        await RemoteRepository().cancelOrder(event.entityId);
        _isCancelOrderSuccess = true;
      } on Failure catch (e) {
        _errorMessage = e.message;
      }
      yield MyOrdersCancelLoaded()
        ..progress = false
        ..cancelOrderSuccess = _isCancelOrderSuccess
        ..errorMessage = _errorMessage;
    }
  }
}
