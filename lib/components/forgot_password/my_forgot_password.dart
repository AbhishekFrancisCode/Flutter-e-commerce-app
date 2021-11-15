import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/components/forgot_password/forgot_password_bloc.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/utils/constants.dart';
import 'forgot_password_bloc.dart';

class MyForgotPasswordPage extends StatelessWidget {
  MyForgotPasswordPage();

  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Forgot your password?"),
        backgroundColor: config.brandColor,
      ),
      body: BlocProvider(
          create: (context) =>
              ForgotPasswordBloc()..add(OnLoadForgotPassword()),
          child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
              builder: (context, state) {
            if (state.forgotPasswordSuccess) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(50),
                height: double.infinity,
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Email has been sent",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Please check your inbox and click in the received link to reset a password",
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Didn't receive the link?",
                      textAlign: TextAlign.center,
                    ),
                    FlatButton(
                      onPressed: () => context
                          .bloc<ForgotPasswordBloc>()
                          .add(OnRetryClicked()),
                      child: Text(
                        "Retry",
                        style: TextStyle(color: Colors.blue),
                      ),
                      color: Colors.blue[50],
                    )
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
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Text(
                        'Enter your registered email below to receive password reset instructions',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, height: 1.5),
                      )),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        focusNode: _emailFocus,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email Address',
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      state.progress
                          ? Container(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator())
                          : Container(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () =>
                                    _onForgotPasswordClicked(context),
                                color: config.brandColor,
                                textColor: Colors.white,
                                child: Text("SEND"),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }

  _onForgotPasswordClicked(BuildContext context) {
    if (_formKey.currentState.validate()) {
      final event = OnForgotPasswordClicked(email: _emailController.text);
      context.bloc<ForgotPasswordBloc>().add(event);
    }
  }
}
