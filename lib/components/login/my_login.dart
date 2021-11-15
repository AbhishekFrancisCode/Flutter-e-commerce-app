import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:toast/toast.dart';
import 'package:vismaya/components/signup/my_signup.dart';
import 'package:vismaya/components/forgot_password/my_forgot_password.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/utils/constants.dart';
import 'package:vismaya/utils/utils.dart';

import 'my_login_bloc.dart';

class MyLogInPage extends StatelessWidget {
  String email = "";
  MyLogInPage({this.email = ""});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _emailController.text = email;
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
          create: (context) => LoginBloc()..add(OnLoadLogin()),
          child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            if (state.logInSuccess) {
              Toast.show("Log in successful", context);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Phoenix.rebirth(context);
              });
            }
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Visibility(
                          visible: state.errorMessage.isNotEmpty,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: Colors.red[100],
                            child: Text(state.errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red)),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _emailFocus,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty ||
                              !RegExp(kEmailPattern).hasMatch(value)) {
                            FocusScope.of(context).requestFocus(_emailFocus);
                            return "Enter email address";
                          }
                          return null;
                        },
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _passwordFocus,
                        obscureText: !state.showPassword,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                            return "Enter password";
                          }
                          return null;
                        },
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () => context
                            .bloc<LoginBloc>()
                            .add(OnShowPasswordClicked(!state.showPassword)),
                        title: Row(
                          children: [
                            Icon(state.showPassword
                                ? Icons.check_box
                                : Icons.check_box_outline_blank),
                            SizedBox(width: 5),
                            Text("Show password"),
                          ],
                        ),
                      ),
                      state.progress
                          ? Container(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator())
                          : Container(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () => _onLoginClicked(context),
                                color: config.brandColor,
                                textColor: Colors.white,
                                child: Text("LOG IN"),
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () {
                          Utils.navigateToPage(context, MyForgotPasswordPage());
                        },
                        textColor: Colors.blue,
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        onPressed: () {
                          final route = Utils.getRoute(context, MySignUpPage());
                          Navigator.pushReplacement(context, route);
                        },
                        textColor: Colors.blue,
                        child: Text(
                          "New user? Create an account",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }

  _onLoginClicked(BuildContext context) {
    if (_formKey.currentState.validate()) {
      final event = OnLoginClicked(
          email: _emailController.text, password: _passwordController.text);
      context.bloc<LoginBloc>().add(event);
    }
  }
}
