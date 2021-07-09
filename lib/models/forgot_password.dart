import 'dart:convert';

class ForgotPasswordRequest {
  String email = "";
 

  ForgotPasswordRequest({
    this.email = "",
  });

  String toRequestJsonFP() => jsonEncode({
          "email": email,
          "template": "email_reset",
      });
}
