import 'package:flutter/material.dart';
import 'package:voting_app/services/main_model.dart';

import 'global/constant.dart';
import 'global/widgets/custom_app_bar.dart';

class Home extends StatefulWidget {
  final MainModel model;
  Home(this.model);
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar.getAppBar(
        context,
        Row(
          children: <Widget>[Text('Inicio')],
        ),
      ),
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
}
