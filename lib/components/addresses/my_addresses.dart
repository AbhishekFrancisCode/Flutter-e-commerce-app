import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/checkout/address/my_address.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/models/address.dart';
import 'package:vismaya/models/address_type.dart';
import 'package:vismaya/models/customer.dart';

import 'addresses_bloc.dart';

class MyAddressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAddressesBloc()..add(OnLoadAddresses()),
      child: BlocBuilder<MyAddressesBloc, AddressesState>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("My Addresses"),
            backgroundColor: config.brandColor,
            actions: [
              // IconButton(
              //     icon: Icon(Icons.add_outlined),
              //     onPressed: () => _onAddOrEditAddress(context, Address()))
            ],
          ),
          body: _getBody(context, state),
        );
      }),
    );
  }

  _getBody(BuildContext context, AddressesState state) {
    if (state is AddressesLoaded) {
      final shipping = state.shipping;
      final billing = state.billing;
      final customerInfo = state.customerInfo;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _getAddressWidget(
              context, shipping, AddressType.SHIPPING, customerInfo),
          SizedBox(
            height: 10,
          ),
          _getAddressWidget(context, billing, AddressType.BILLING, customerInfo)
        ],
      );
    } else if (state is AddressesError) {
      return ShowErrorWidget(
        state.errorMessage,
        onPressed: () => context.bloc<MyAddressesBloc>().add(OnLoadAddresses()),
      );
    }
    return ProgressIndicatorWidget();
  }

  Widget _getAddressWidget(BuildContext context, Address address,
      AddressType addressType, Customer customerInfo) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(addressType.label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      SizedBox(
        height: 5,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: address != null && !address.isEmpty(),
            child: Text(address.toString(),
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            replacement: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Add address",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    color: Colors.blue),
              ),
            ),
          ),
          TextButton(
              child: Text(
                "Edit",
                style: TextStyle(color: config.brandColor),
              ),
              onPressed: () => _onAddOrEditAddress(
                  context, address, addressType, customerInfo))
        ],
      ),
    ]);
  }

  _onAddOrEditAddress(BuildContext context, Address address,
      AddressType addressType, Customer customerInfo) async {
    final widget = MyAddressPage(
      address,
      addressType,
      customerInfo: customerInfo,
      saveAddress: true,
    );
    final route = MaterialPageRoute<Address>(builder: (context) => widget);
    final result = await Navigator.push(context, route);
    if (result != null) {
      context.bloc<MyAddressesBloc>().add(OnLoadAddresses());
    }
  }
}
