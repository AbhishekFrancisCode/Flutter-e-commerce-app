import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/components/addresses/my_addresses.dart';
import 'package:vismaya/config.dart';
import 'package:vismaya/utils/utils.dart';

import 'my_account_bloc.dart';

class MyAccountPage extends StatelessWidget {
  MyAccountPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: config.brandColor,
        title: Text("My account"),
      ),
      body: BlocProvider(
          create: (context) => MyAccountBloc()..add(OnLoadMyAccount()),
          child: BlocBuilder<MyAccountBloc, MyAccountState>(
              builder: (context, state) {
            if (state is MyAccountLoaded) {
              final customer = state.customer;
              return ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("${customer.firstname} ${customer.lastname}"),
                    subtitle: Text(customer.email),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text("My Addresses"),
                    trailing: Icon(Icons.chevron_right_outlined),
                    onTap: () =>
                        Utils.navigateToPage(context, MyAddressesPage()),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Log out"),
                    onTap: () => _onLogOutPressed(context),
                  )
                ],
              );
            }
            return ProgressIndicatorWidget();
          })),
    );
  }

  _onLogOutPressed(BuildContext context) async {
    final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Do you want to log out?"),
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context, true),
              )
            ],
          );
        });

    if (result != null && result) {
      context.bloc<MyAccountBloc>().add(OnLogOutMyAccount());
      Phoenix.rebirth(context);
    }
  }
}
