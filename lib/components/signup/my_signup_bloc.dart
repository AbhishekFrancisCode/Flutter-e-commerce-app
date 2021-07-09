import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/models/sign_up_request.dart';
import 'package:vismaya/repositories/local/pref_manager.dart';
import 'package:vismaya/repositories/remote/failure.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';

abstract class SignUpEvent {}

class OnLoadSignUp extends SignUpEvent {}

class OnSignUpClicked extends SignUpEvent {
  String firstname;
  String lastname;
  String email;
  String password;
  OnSignUpClicked({this.firstname, this.lastname, this.email, this.password});
}

class OnShowPasswordClicked extends SignUpEvent {
  final bool showPassword;
  OnShowPasswordClicked(this.showPassword);
}

//States
abstract class SignUpState {
  bool progress = false;
  bool showPassword = false;
  bool signUpSuccess = false;
  String errorMessage = "";
  SignUpState();
}

class SignUpFormLoaded extends SignUpState {}

//Bloc
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpFormLoaded());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is OnLoadSignUp) {
      yield SignUpFormLoaded();
    } else if (event is OnSignUpClicked) {
      yield SignUpFormLoaded()..progress = true;
      String errorMessage = "";
      final request = SignUpRequest(
          firstname: event.firstname,
          lastname: event.lastname,
          email: event.email,
          password: event.password);
      bool isSignUpSuccess = false;
      try {
        final response = await RemoteRepository().customerSignUp(request);
        final customer = response.data;
        prefManager.setCustomerInfo(customer);
        isSignUpSuccess = true;
      } on Failure catch (e) {
        errorMessage = e.message;
      }
      yield SignUpFormLoaded()
        ..progress = false
        ..signUpSuccess = isSignUpSuccess
        ..errorMessage = errorMessage;
    } else if (event is OnShowPasswordClicked) {
      yield SignUpFormLoaded()..showPassword = event.showPassword;
    }
  }
}
