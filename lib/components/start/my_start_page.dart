import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vismaya/common/progress_indicator_widget.dart';
import 'package:vismaya/common/show_error_widget.dart';
import 'package:vismaya/components/cart/my_cart.dart';
import 'package:vismaya/components/categories/my_categories.dart';
import 'package:vismaya/components/home/my_home.dart';
import 'package:vismaya/components/profile/my_profile_page.dart';
import 'package:vismaya/config.dart';

import 'start_bloc.dart';

class MyStartPage extends StatelessWidget {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyHomePage(),
    MyCategoriesPage(),
    MyProfilePage(),
    MyCartPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<StartBloc>(
        create: (context) => StartBloc()..add(OnLoadStart(_currentIndex)),
        child: BlocBuilder<StartBloc, StartState>(
          builder: (context, state) {
            if (state is StartTabSelected) {
              _currentIndex = state.tabPosition;
              final cartItemCount = config.cart.skuCartMap.length;
              final _items = _getBottomNavigationItems();
              if (cartItemCount > 0) {
                _badger.setBadge(_items, "$cartItemCount", 3);
              } else {
                _badger.removeBadge(_items, 3);
              }
              return Scaffold(
                body: _children[_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                  items: _items,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  selectedItemColor: config.brandColor,
                  onTap: (index) =>
                      context.bloc<StartBloc>().add(OnStartTabPressed(index)),
                ),
              );
            } else if (state is StartError) {
              return ShowErrorWidget(
                state.errorMessage,
                onPressed: () =>
                    context.bloc<StartBloc>().add(OnLoadStart(_currentIndex)),
              );
            }
            return ProgressIndicatorWidget();
          },
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomNavigationItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
      BottomNavigationBarItem(
          icon: Icon(Icons.view_list), title: Text("Categories")),
      BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("Profile")),
      BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart), title: Text("Cart"))
    ];
  }

  BottomNavigationBadge _badger = BottomNavigationBadge(
      backgroundColor: Colors.red,
      badgeShape: BottomNavigationBadgeShape.circle,
      textColor: Colors.white,
      position: BottomNavigationBadgePosition.topRight,
      textSize: 10);
}
