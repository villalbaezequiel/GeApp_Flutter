import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:voting_app/ui/global/constant.dart';

import 'global/widgets/custom_app_bar.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final floatingAction = UnicornDialer(
      parentButtonBackground: Constant.ascent,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(
        Icons.add,
        color: Colors.white,
      ),
      childButtons: _getProfileMenu(),
    );

    return new Scaffold(
      appBar: CustomAppBar.getAppBar('Inicio', context),
      backgroundColor: Colors.white,
      // floatingActionButton: floatingAction,
      body: ListView(
        children: <Widget>[
          Image.asset(
            'assets/images/logo2.png',
            height: 150,
          ),
          SizedBox(height: 30),
          homeButton('Agregar amigo', '/add_friend', Icons.person_add),
          homeButton('Mis amigos', '/friends_list', Icons.group),
          homeButton('Ver mi mesa', '/my_voting_table_list', Icons.list),
          homeButton('Escrutinio', '/escrutinio', Icons.check_circle),
          homeButton('Ayuda', '/help', Icons.help_outline),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Container homeButton(String title, String path, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        gradient: Constant.gradient,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(path);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(
      _profileOption(
        txt: 'Voto',
        iconData: Icons.email,
        onPressed: () {
          _asyncInputDialogVote(context);
        },
      ),
    );
    children.add(
      _profileOption(
        txt: 'Reposición',
        iconData: Icons.library_books,
        onPressed: () {
          _asyncInputDialog(context);
        },
      ),
    );

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
