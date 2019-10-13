import 'package:flutter/material.dart';
import 'package:voting_app/ui/global/widgets/navigation_drawer.dart';

import 'model/drawer_item.dart';
import 'ui/add_friend.dart';
import 'ui/escrutinio.dart';
import 'ui/friends_list.dart';
import 'ui/global/constant.dart';
import 'ui/help.dart';
import 'ui/home.dart';
import 'ui/login.dart';
import 'ui/my_voting_table.dart';
import 'ui/person.dart';
import 'ui/sign_up.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chubut al Frente',
      theme: ThemeData(
        primaryColor: Constant.primary,
        accentColor: Constant.ascent,
        scaffoldBackgroundColor: Constant.bgColor,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/add_friend': (context) => AddFriend(),
        '/friends_list': (context) => FriendsList(),
        '/my_voting_table_list': (context) => MyVotingTableList(),
        '/person_details': (context) => PersonDetails(),
        '/escrutinio': (context) => Escrutinio(),
        '/help': (context) => Help(),
        '/login': (context) => Login(),
        '/sign_up': (context) => SignUp(),
      },
      builder: (context, child) {
        // 2
        return ShareDrawer(
          navigator: (child.key as GlobalKey<NavigatorState>),
          child: child,
        );
      },
    );
  }
}

class ShareDrawer extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final Widget child;
  final List<DrawerItem> drawerItems = [
    DrawerItem("Inicio", Icons.dashboard, '/'),
    DrawerItem("Agregar Amigo", Icons.person_add, '/add_friend'),
    DrawerItem("Amigos", Icons.group, '/friends_list'),
    DrawerItem("Mi Mesa", Icons.list, '/my_voting_table_list'),
    DrawerItem("Escrutinio", Icons.check_circle, '/escrutinio'),
    DrawerItem("Ayuda", Icons.help, '/help'),
    DrawerItem("Salir", Icons.exit_to_app, '/login'),
  ];

  ShareDrawer({Key key, this.navigator, this.child}) : super(key: key);

  @override
  _ShareDrawerState createState() => _ShareDrawerState();
}

class _ShareDrawerState extends State<ShareDrawer> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(
        drawerItems: widget.drawerItems,
        selectedIndex: _selectedIndex,
        headerView: UserAccountsDrawerHeader(
          accountName: Text('Pedro Gonzalez'),
          accountEmail: Text('DNI: 30123456'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              'P',
              style: TextStyle(fontSize: 40.0),
            ),
          ),
        ),
        onNavigationItemSelect: (index) {
          String route = widget.drawerItems[index].route;
          if (_selectedIndex == index) return true;
          (index == 0 || index == (widget.drawerItems.length - 1))
              ? widget.navigator.currentState.pushNamedAndRemoveUntil(
                  route,
                  (Route<dynamic> route) => false,
                )
              : widget.navigator.currentState.pushNamed(route);
          setState(() {
            _selectedIndex = index;
          });
          return true; // true means that drawer must close and false is Vice versa
        },
      ),
      body: widget.child,
    );
  }
}
