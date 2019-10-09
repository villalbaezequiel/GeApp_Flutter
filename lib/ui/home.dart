import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';

import 'add_friend.dart';
import 'friends_list.dart';
import 'help.dart';
import 'my_voting_table.dart';
import 'sign_up.dart';
import 'supervise.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectDrawerItem = 0;
  String _title = 'Adherir';

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(_title),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.search),
        )
      ],
    );

    final myDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Pedro Gonzalez'),
            accountEmail: Text('DNI: 30123456'),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  'P',
                  style: TextStyle(fontSize: 40.0),
                )),
          ),
          ListTile(
              title: Text('Amigos'),
              leading: Icon(Icons.people),
              selected: (1 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(1, 'Amigos (24)');
              }),
          ListTile(
              title: Text('Mi Mesa'),
              leading: Icon(Icons.format_list_bulleted),
              selected: (2 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(2, 'Mi Mesa (17/254)');
              }),
          ListTile(
              title: Text('Escrutinio'),
              leading: Icon(Icons.email),
              selected: (3 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(3, 'Escrutinio');
              }),
          ListTile(
              title: Text('Asistencia'),
              leading: Icon(Icons.help),
              selected: (4 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(4, 'Asistencia');
              }),
          Divider(),
          ListTile(
              title: Text('Salir'),
              leading: Icon(Icons.exit_to_app),
              selected: (5 == _selectDrawerItem),
              onTap: () {
                _onSelectItem(5, '');
              }),
        ],
      ),
    );

    final floatingAction = UnicornDialer(
      parentButtonBackground: Theme.of(context).accentColor,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: _getProfileMenu(),
    );

    return new Scaffold(
      appBar: appBar,
      drawer: myDrawer,
      body: _getDrawerItemWidget(_selectDrawerItem),
      floatingActionButton: floatingAction,
    );
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return AddFriend();
      case 1:
        return FriendsList();
      case 2:
        return MyVotingTableList();
      case 3:
        return Supervise();
      case 4:
        return Help();
      case 5:
        //return Login();
        return SignUp();
    }
  }

  _onSelectItem(int pos, String title) {
    Navigator.pop(context);
    setState(() {
      _selectDrawerItem = pos;
      _title = title;
    });
  }

  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(_profileOption(
        txt: 'Voto',
        iconData: Icons.email,
        onPressed: () {
          _asyncInputDialogVote(context);
        }));
    children.add(_profileOption(
        txt: 'Reposición',
        iconData: Icons.library_books,
        onPressed: () {
          _asyncInputDialog(context);
        }));

    return children;
  }

  Future<String> _asyncInputDialogVote(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Voto'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Ingrese el número de orden',
                    hintText: 'ejemplo 154'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reposición de boletas'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Cantidad boletas repuestas',
                    hintText: 'ejemplo 25'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _profileOption({String txt, IconData iconData, Function onPressed}) {
    return UnicornButton(
        labelText: txt,
        labelHasShadow: true,
        labelColor: Theme.of(context).accentColor,
        hasLabel: true,
        currentButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          foregroundColor: Colors.white,
          mini: true,
          child: Icon(iconData),
          onPressed: onPressed,
        ));
  }
}
