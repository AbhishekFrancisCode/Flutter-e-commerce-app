import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vismaya/components/profile/cms_page.dart';
import 'package:vismaya/components/profile/my_profile_page.dart';
import 'package:vismaya/utils/utils.dart';

class PaymentInstructionsWidget extends StatelessWidget {
  const PaymentInstructionsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Utils.navigateToPage(context, MyCMSPage("FAQ", kFaqUrl)),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        color: Colors.blue[100],
        child: Text(
          "Please check payment instructions in FAQ section",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
