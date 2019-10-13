import 'package:flutter/material.dart';
import 'package:voting_app/model/drawer_item.dart';

import 'root_scaffold.dart';

typedef bool OnNavigationItemSelect(int index);

typedef Widget NavigationRowItemBuilder(BuildContext context, DrawerItem item);

class NavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final List<DrawerItem> drawerItems;
  final OnNavigationItemSelect onNavigationItemSelect;

  // final NavigationRowItemBuilder navigationRowItemBuilder;
  final Widget headerView;

  const NavigationDrawer(
      {Key key,
      this.drawerItems,
      this.onNavigationItemSelect,
      this.headerView,
      this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = RootDrawer.of(context);
    List<Widget> drawerOptions = [];
    drawerOptions.add(headerView);
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      if (i == drawerItems.length - 1) {
        drawerOptions.add(Divider());
      }
      drawerOptions.add(
        ListTile(
          leading: Icon(d.icon),
          title: Text(
            d.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
          ),
          selected: i == selectedIndex,
          onTap: () {
            if (onNavigationItemSelect(i)) {
              state.close();
            }
          },
        ),
      );
    }
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: drawerOptions),
    );
  }
}
