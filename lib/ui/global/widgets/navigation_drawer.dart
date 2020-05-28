import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/drawer_item.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';

import '../utils/constant.dart';

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
    widget.model.loadUser(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final List<DrawerItem> drawerItems = [
      DrawerItem("Inicio", Icons.dashboard, '/home'),
      DrawerItem("Consulta de Seccion", Icons.search, '/scpl/fetch_client'),
      DrawerItem("Agregar Amigo", Icons.person_add, '/add_friend'),
      DrawerItem("Amigos", Icons.group, '/friends_list'),
      DrawerItem("Mi Mesa", Icons.list, '/my_voting_table_list'),
      DrawerItem("Escrutinio", Icons.check_circle, '/escrutinio'),
      DrawerItem("Chat", Icons.help, '/help'),
      DrawerItem("Salir", Icons.exit_to_app, '/login'),
    ];
    List<Widget> drawerOptions = [];

    // Widget headerView = UserAccountsDrawerHeader(
    //   key: Key("geapp_nav_drawer"),
    //   decoration: BoxDecoration(gradient: Constant.appBarGradient),
    //   accountName: Text(
    //     (widget.model.user == null || widget.model.user.firstName == null)
    //         ? "GeApp"
    //         : (widget.model.user.firstName.toString() +
    //             " " +
    //             widget.model.user.lastName.toString()),
    //   ),
    //   accountEmail: Text(
    //     (widget.model.user == null)
    //         ? "DNI: 1234567890"
    //         : "DNI: ${widget.model.user.nationalId.toString()}",
    //   ),
    //   currentAccountPicture: CircleAvatar(
    //     backgroundColor: Colors.blue,
    //     child: Container(
    //       margin: EdgeInsets.all(10),
    //       child: Text(
    //         (widget.model.user == null || widget.model.user.firstName == null)
    //             ? "G"
    //             : widget.model.user.firstName[0].toUpperCase(),
    //         style: TextStyle(fontSize: 30.0),
    //       ),
    //     ),
    //   ),
    // );

    Widget headerView = Container(
      padding: EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(gradient: Constant.gradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 35,
            child: Container(
              child: Text(
                (widget.model.user == null ||
                        widget.model.user.firstName == null)
                    ? "G"
                    : widget.model.user.firstName[0].toUpperCase(),
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            (widget.model.user == null || widget.model.user.firstName == null)
                ? "GeApp"
                : (widget.model.user.firstName.toString() +
                    " " +
                    widget.model.user.lastName.toString()),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            (widget.model.user == null)
                ? "DNI: 1234567890"
                : "DNI: ${widget.model.user.nationalId.toString()}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );

    drawerOptions.add(headerView);

    String currentRoute(context) {
      String currentRoute = '';
      Navigator.popUntil(context, (route) {
        currentRoute = route.settings.name;
        return true;
      });
      return currentRoute;
    }

    for (var index = 0; index < drawerItems.length; index++) {
      var currentDrawerItem = drawerItems[index];
      if (index == drawerItems.length - 1) {
        drawerOptions.add(Divider());
      }
      drawerOptions.add(
        ListTile(
          enabled: widget.model.checkEnablity(currentDrawerItem.route),
          leading: Icon(currentDrawerItem.icon),
          title: Text(
            currentDrawerItem.title,
            style: TextStyleUtils.drawerTextStyle,
          ),
          selected: (currentDrawerItem.route == currentRoute(context)),
          onTap: () {
            Navigator.of(context).pop();
            if (currentDrawerItem.route == currentRoute(context)) return true;

            switch (currentDrawerItem.route) {
              case "/home":
                Navigator.of(context).pushNamedAndRemoveUntil(
                    currentDrawerItem.route, (Route<dynamic> route) => false);
                break;

              case "/login":
                widget.model.commonWidgest.progressDialog(context);
                widget.model.logout(widget.model, context);
                break;

              case "/help":
                widget.model.openWhatsApp(widget.model);
                break;

              default:
                Navigator.of(context).pushNamed(currentDrawerItem.route);
            }
            return true;
          },
        ),
      );
    }

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Drawer(
          child: ListView(padding: EdgeInsets.zero, children: drawerOptions),
        );
      },
    );
  }
}
