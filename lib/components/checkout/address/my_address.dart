import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vismaya/common/widget/switch_textview.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/address_type.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/customer.dart';
import 'package:vismaya/repositories/remote/remote_repository.dart';
import 'package:vismaya/utils/constants.dart';

class MyAddressPage extends StatelessWidget {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _phoneController = TextEditingController();
  final _postcodeController = TextEditingController();

  final _firstnameFocus = FocusNode();
  final _lastnameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _addressLine1Focus = FocusNode();
  final _addressLine2Focus = FocusNode();
  final _phoneFocus = FocusNode();
  final _postcodeFocus = FocusNode();

  final _cities = ["Bangalore"];
  final _countries = ["India"];
  final _states = ["Karnataka"];
  String _selectedZipCode = "";
  String _citySelection = "Bangalore";

  final _formKey = GlobalKey<FormState>();
  final _zipCodes = List<String>();

  final AddressType addressType;
  final Address address;
  final bool saveAddress;
  final Customer customerInfo;
  MyAddressPage(this.address, this.addressType,
      {this.customerInfo, this.saveAddress = false}) {
    final streets = address.streets;
    _firstnameController.text = address.firstname?.trim() ?? "";
    _lastnameController.text = address.lastname?.trim() ?? "";
    _phoneController.text = address.telephone?.trim() ?? "";
    _emailController.text = address.email?.trim() ?? "";
    _addressLine1Controller.text =
        streets.length > 0 ? streets[0]?.trim() ?? "" : null;
    _addressLine2Controller.text =
        streets.length > 1 ? streets[1]?.trim() ?? "" : null;
    _selectedZipCode = address.postcode?.trim();
    _postcodeController.text = address.postcode?.trim() ?? "";
    //Prepend an empty string to zipcodes
    _zipCodes.add("");
    _zipCodes.addAll(config.zipCodes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.brandColor,
        title: Text(addressType.label),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 30, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  focusNode: _firstnameFocus,
                  decoration: InputDecoration(
                      labelText: 'First Name', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  controller: _firstnameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isNotEmpty) return null;
                    FocusScope.of(context).requestFocus(_firstnameFocus);
                    return "Enter first name";
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(_lastnameFocus);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _lastnameFocus,
                  decoration: InputDecoration(
                      labelText: 'Last Name', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  controller: _lastnameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isNotEmpty) return null;
                    FocusScope.of(context).requestFocus(_lastnameFocus);
                    return "Enter last name";
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(_phoneFocus);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _phoneFocus,
                  decoration: InputDecoration(
                      labelText: 'Phone Number (10 digits, without +91)',
                      hintText: 'For e.g., 9449432940 or 8025218753',
                      border: OutlineInputBorder()),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.length == 10) return null;
                    FocusScope.of(context).requestFocus(_phoneFocus);
                    return "Enter phone number";
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(_emailFocus);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: config.isGuest,
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: _emailFocus,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
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
                          FocusScope.of(context)
                              .requestFocus(_addressLine1Focus);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  focusNode: _addressLine1Focus,
                  decoration: InputDecoration(
                      labelText: 'Address Line1', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: _addressLine1Controller,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.isNotEmpty) return null;
                    FocusScope.of(context).requestFocus(_addressLine1Focus);
                    return "Enter address";
                  },
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(_addressLine2Focus);
                  },
                  maxLines: null,
                  maxLength: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  focusNode: _addressLine2Focus,
                  decoration: InputDecoration(
                      labelText: 'Address Line2', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: _addressLine2Controller,
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: (v) {
                    // FocusScope.of(context).requestFocus(FocusNode());
                  },
                  maxLines: null,
                  maxLength: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'City', border: OutlineInputBorder()),
                    value: _cities[0],
                    items: _cities.map((e) {
                      return DropdownMenuItem<String>(value: e, child: Text(e));
                    }).toList(),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter city";
                      }
                      return null;
                    },
                    onChanged: (value) {}),

                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'State', border: OutlineInputBorder()),
                    value: _states[0],
                    items: _states.map((e) {
                      return DropdownMenuItem<String>(value: e, child: Text(e));
                    }).toList(),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter state";
                      }
                      return null;
                    },
                    onChanged: (value) {}),

                SizedBox(
                  height: 10,
                ),

                // DropdownButtonFormField<String>(
                //     decoration: InputDecoration(
                //         labelText: 'Country',
                //         border: OutlineInputBorder()),
                //     value: _countries[0],
                //     items: _countries.map((e) {
                //       return DropdownMenuItem<String>(
                //           value: e, child: Text(e));
                //     }).toList(),
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return "Enter state";
                //       }
                //       return null;
                //     },
                //     onChanged: (value) {
                //       selectedZipCode = value;
                //     }),
                SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'Pincode', border: OutlineInputBorder()),
                    value: _selectedZipCode,
                    items: _zipCodes.map((e) {
                      return DropdownMenuItem<String>(value: e, child: Text(e));
                    }).toList(),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter pincode";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _selectedZipCode = value;
                    }),
                SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   focusNode: _postcodeFocus,
                //   decoration: InputDecoration(
                //       labelText: 'Postcode',
                //       border: OutlineInputBorder()),
                //   keyboardType: TextInputType.number,
                //   controller: _postcodeController,
                //   validator: (value) {
                //     if (value.isNotEmpty) return null;
                //     FocusScope.of(context).requestFocus(_postcodeFocus);
                //     return "Enter post code";
                //   },
                //   onFieldSubmitted: (v) {
                //     FocusScope.of(context).requestFocus(_postcodeFocus);
                //   },
                //   maxLines: 1,
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Visibility(
                //     visible: saveAddress,
                //     child: Column(
                //       children: [
                //         SwitchTextView(
                //             value: address.defaultShipping,
                //             title: Text("Default Shipping address"),
                //             onValueChanged: (value) {
                //               address.defaultShipping = value;
                //             }),
                //         SwitchTextView(
                //             value: address.defaultBilling,
                //             title: Text("Default Billing address"),
                //             onValueChanged: (value) {
                //               address.defaultBilling = value;
                //             }),
                //       ],
                //     )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: RaisedButton(
                    color: config.brandColor,
                    textColor: Colors.white,
                    onPressed: () => _handleAddressSubmission(context),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleAddressSubmission(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      final focusNode = _getFocusNode();
      FocusScope.of(context).requestFocus(focusNode);
      return;
    }

    address.firstname = _firstnameController.text;
    address.lastname = _lastnameController.text;
    address.email = _emailController.text;
    address.telephone = _phoneController.text;
    address.city = _cities[0];
    address.countryId = "IN";
    address.region = _states[0];
    address.regionId = 549;
    address.regionCode = "KA";
    address.postcode = _selectedZipCode;

    address.streets = [_addressLine1Controller.text];
    final addrLine2 = _addressLine2Controller.text;
    if (addrLine2 != null && addrLine2.isNotEmpty) {
      address.streets.add(addrLine2);
    }

    if (saveAddress) {
      final pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
      );
      pr.style(message: "Saving...");
      await pr.show();
      //Save address
      try {
        await RemoteRepository().putCustomerInfo(customerInfo);
      } catch (e) {}
      await pr.hide();
    }

    Navigator.of(context).pop(address);
  }

  FocusNode _getFocusNode() {
    if (_firstnameController.text.isEmpty) return _firstnameFocus;
    if (_lastnameController.text.isEmpty) return _lastnameFocus;
    if (_emailController.text.isEmpty) return _emailFocus;
    if (_phoneController.text.isEmpty) return _phoneFocus;
    if (_addressLine1Controller.text.isEmpty) return _addressLine1Focus;
    return FocusNode();
  }
}
