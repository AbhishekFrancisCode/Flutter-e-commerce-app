//Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';
import 'package:vismaya/models/forgot_password.dart';

abstract class ForgotPasswordEvent {}

class OnLoadForgotPassword extends ForgotPasswordEvent {}

class OnForgotPasswordClicked extends ForgotPasswordEvent {
  String email;
  OnForgotPasswordClicked({this.email});
}

class OnRetryClicked extends ForgotPasswordEvent {}

//States
abstract class ForgotPasswordState {
  bool progress = false;
  bool forgotPasswordSuccess = false;
  String errorMessage = "";
  ForgotPasswordState();
}

class ForgotPasswordLoaded extends ForgotPasswordState {}

//Bloc
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordLoaded());
  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is OnLoadForgotPassword) {
      yield ForgotPasswordLoaded();
    } else if (event is OnForgotPasswordClicked) {
      yield ForgotPasswordLoaded()..progress = true;
      final request = ForgotPasswordRequest(
        email: event.email,
      );
      bool _isforgotPasswordSuccess = false;
      String _errorMessage = "";
      try {
        await RemoteRepository().customerForgotPassword(request);
        _isforgotPasswordSuccess = true;
      } on Failure catch (e) {
        _errorMessage = e.message;
      }
      yield ForgotPasswordLoaded()
        ..progress = false
        ..forgotPasswordSuccess = _isforgotPasswordSuccess
        ..errorMessage = _errorMessage;
    } else if (event is OnRetryClicked) {
      yield ForgotPasswordLoaded();
    }
  }
}
