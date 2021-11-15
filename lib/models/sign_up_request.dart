import 'dart:convert';

class SignUpRequest {
  String firstname = "";
  String lastname = "";
  String email = "";
  String password = "";

  SignUpRequest({
    this.firstname = "",
    this.lastname = "",
    this.email = "",
    this.password = "",
  });

  String toRequestJson() => jsonEncode({
        "customer": {
          "firstname": firstname,
          "lastname": lastname,
          "email": email,
        },
        "password": password
      });
}
