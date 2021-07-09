import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:vismaya/models/product_variant.dart';

class Utils {
  static void showErrorToast(String msg, BuildContext context) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.red);
  }

  static void showAlertDialog(
      BuildContext context, String title, String content) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static MaterialPageRoute getRoute(
      BuildContext context, StatelessWidget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }

  static navigateToPage(BuildContext context, Widget widget) {
    final route = Utils.getRoute(context, widget);
    Navigator.push(context, route);
  }

  // static Future<void> sendSupportEmail([String signature = '']) async {
  //   final model = await getDeviceModel();
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   final email = Email(
  //     body: '\n\n\n----\n$model\n$signature',
  //     subject: 'Actiwoo Support ${packageInfo.version}',
  //     recipients: ['support@actiwoo.com'],
  //   );
  //   await FlutterEmailSender.send(email);
  // }

  static trucateIfZero(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  static double getDouble(dynamic value) {
    final text = value?.toString() ?? "";
    return text.isEmpty ? 0.0 : double.parse(text);
  }

  static Future<String> getDeviceModel() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return '${info.model}, v${info.version.release}';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return '${info.utsname.machine}';
    }
    return '';
  }

  static bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= minLength;

    return hasDigits &
        // hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
  }

  static Widget displayPriceInfo(ProductVariant variant) {
    final hasSpecialPrice = variant.getSpecialPrice() > 0;
    final specialPrice = variant.getFormattedSpecialPrice();
    final price = variant.getFormattedPrice();
    final price1 = hasSpecialPrice ? specialPrice : price;
    final price2 = hasSpecialPrice ? price : specialPrice;
    final price1Widget =
        Text(price1, style: TextStyle(fontWeight: FontWeight.bold));
    final price2Widget = Text(
      price2,
      style: TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationColor: Colors.black54),
    );

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Wrap(
        children: [
          price1Widget,
          SizedBox(
            width: 10,
          ),
          Visibility(visible: hasSpecialPrice, child: price2Widget)
        ],
      ),
    );
  }

  // the list of positive integers starting from 0
  static Iterable<int> get positiveIntegers sync* {
    int i = 0;
    while (true) yield i++;
  }

  static Color getColorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return hexCode.isEmpty
        ? Colors.transparent
        : Color(int.parse(hexCode, radix: 16));
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    final pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (phoneNumber == null || phoneNumber.isEmpty) {
      return false;
    }

    if (!regExp.hasMatch(phoneNumber)) {
      return false;
    }
    return true;
  }

  static void insertionSort<T>(List<T> list, int Function(T, T) compare) {
    for (var pos = 1; pos < list.length; pos++) {
      var min = 0;
      var max = pos;
      var element = list[pos];
      while (min < max) {
        var mid = min + ((max - min) >> 1);
        var comparison = compare(element, list[mid]);
        if (comparison < 0) {
          max = mid;
        } else {
          min = mid + 1;
        }
      }
      list.setRange(min + 1, pos + 1, list, min);
      list[min] = element;
    }
  }
}
