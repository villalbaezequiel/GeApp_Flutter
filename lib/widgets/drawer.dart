import 'package:flutter/material.dart';

Widget drawer() {
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.all(0.0),
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: Text('sahsantoshh@gmail.com'),
          accountName: Text('Santosh Sah'),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              'S',
              style: TextStyle(fontSize: 26),
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.group,
          ),
          title: Text('Amigos'),
        ),
        ListTile(
          leading: Icon(
            Icons.list,
          ),
          title: Text('Mi Mesa'),
        ),
        ListTile(
          leading: Icon(
            Icons.help,
          ),
          title: Text('Assistencia'),
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
          ),
          title: Text('Salir'),
        ),
      ],
    ),
  );
}
