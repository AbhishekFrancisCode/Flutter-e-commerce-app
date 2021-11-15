import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class LoginEvent {}

class OnLoadLogin extends LoginEvent {}

class OnLoginClicked extends LoginEvent {
  String email;
  String password;
  OnLoginClicked({this.email, this.password});
}

class OnShowPasswordClicked extends LoginEvent {
  final bool showPassword;
  OnShowPasswordClicked(this.showPassword);
}

//States
abstract class LoginState {
  bool progress = false;
  bool showPassword = false;
  bool logInSuccess = false;
  String errorMessage = "";
  LoginState();
}

class LoginFormLoaded extends LoginState {}

//Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginFormLoaded());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is OnLoadLogin) {
      yield LoginFormLoaded();
    } else if (event is OnLoginClicked) {
      yield LoginFormLoaded()..progress = true;
      bool isLogInSuccess = false;
      String errorMessage = "";
      try {
        final email = event.email;
        final password = event.password;
        final response =
            await RemoteRepository().customerToken(email, password);
        final token = response.data;
        prefManager.setCustomerToken(token);
        isLogInSuccess = true;
        final loginResponse = await RemoteRepository().getCustomerInfo();
        final customer = loginResponse.data;
        prefManager.setCustomerInfo(customer);
      } on Failure catch (e) {
        errorMessage = e.message;
      }
      yield LoginFormLoaded()
        ..progress = false
        ..logInSuccess = isLogInSuccess
        ..errorMessage = errorMessage;
    } else if (event is OnShowPasswordClicked) {
      yield LoginFormLoaded()..showPassword = event.showPassword;
    }
  }
}
