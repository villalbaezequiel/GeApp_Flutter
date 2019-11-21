import 'package:flutter/material.dart';
import 'package:voting_app/model/drawer_item.dart';
import 'package:voting_app/services/main_model.dart';

import '../constant.dart';

class NavigationDrawer extends StatefulWidget {
  final MainModel model;
  const NavigationDrawer({Key key, this.model}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  void initState() {
    super.initState();
    if (widget.model.user == null) fetchData();
  }

  Future fetchData() async {
    widget.model.loadUsesr();
  }

  @override
  Widget build(BuildContext context) {
    final List<DrawerItem> drawerItems = [
      DrawerItem("Inicio", Icons.dashboard, '/home'),
      DrawerItem("Agregar Amigo", Icons.person_add, '/add_friend'),
      DrawerItem("Amigos", Icons.group, '/friends_list'),
      DrawerItem("Mi Mesa", Icons.list, '/my_voting_table_list'),
      DrawerItem("Escrutinio", Icons.check_circle, '/escrutinio'),
      DrawerItem("Ayuda", Icons.help, '/help'),
      DrawerItem("Salir", Icons.exit_to_app, '/login'),
    ];
    List<Widget> drawerOptions = [];

    Widget headerView = UserAccountsDrawerHeader(
      decoration: BoxDecoration(gradient: Constant.appBarGradient),
      accountName: Text(
        (widget.model.user == null || widget.model.user.firstName == null)
            ? "GeApp"
            : (widget.model.user.firstName.toString() +
                " " +
                widget.model.user.lastName.toString()),
      ),
      accountEmail: Text((widget.model.user == null)
          ? "DNI: 1234567890"
          : "DNI: ${widget.model.user.nationalId.toString()}"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          (widget.model.user == null || widget.model.user.firstName == null)
              ? "G"
              : widget.model.user.firstName[0].toUpperCase(),
          style: TextStyle(fontSize: 40.0),
        ),
      ),
    );
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
          selected: i == widget.model.getCuttentIndex(),
          onTap: () {},
        ),
      );
    }
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: drawerOptions),
    );
  }
}
