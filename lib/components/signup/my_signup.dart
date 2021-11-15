import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/components/login/my_login.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/utils/constants.dart';
import 'package:vismaya/utils/utils.dart';

import 'my_signup_bloc.dart';

class MySignUpPage extends StatelessWidget {
  MySignUpPage();

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _firstnameFocus = FocusNode();
  final _lastnameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
          create: (context) => SignUpBloc()..add(OnLoadSignUp()),
          child:
              BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
            if (state.signUpSuccess) {
              return Container(
                margin: const EdgeInsets.all(32),
                alignment: Alignment.center,
                height: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Account created",
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                        child: Text("Log in to proceed"),
                        color: config.brandColor,
                        textColor: Colors.white,
                        onPressed: () => _switchToLogInPage(context))
                  ],
                ),
              );
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
                        focusNode: _firstnameFocus,
                        decoration: InputDecoration(
                            labelText: 'Firstname',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.name,
                        controller: _firstnameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            FocusScope.of(context)
                                .requestFocus(_firstnameFocus);
                            return "Enter your first name";
                          }
                          return null;
                        },
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(_lastnameFocus);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        focusNode: _lastnameFocus,
                        decoration: InputDecoration(
                            labelText: 'Lastname',
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.name,
                        controller: _lastnameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            FocusScope.of(context).requestFocus(_lastnameFocus);
                            return "Enter your family name";
                          }
                          return null;
                        },
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                      ),
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
                            return "Enter a valid email address";
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
                          if (value.isEmpty ||
                              !Utils.isPasswordCompliant(value)) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                            return "Weak password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Enter strong password. It should have minimum 8 characters, with at least a digit and a special character",
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () => context
                            .bloc<SignUpBloc>()
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
                                child: Text("SIGN UP"),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      FlatButton(
                        onPressed: () => _switchToLogInPage(context),
                        textColor: Colors.blue,
                        child: Text(
                          "Already a user? Log in",
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
      final event = OnSignUpClicked(
          firstname: _firstnameController.text,
          lastname: _lastnameController.text,
          email: _emailController.text,
          password: _passwordController.text);
      context.bloc<SignUpBloc>().add(event);
    }
  }

  _switchToLogInPage(BuildContext context) {
    final email = _emailController.text;
    final route = Utils.getRoute(context, MyLogInPage(email: email));
    Navigator.pushReplacement(context, route);
  }
}
