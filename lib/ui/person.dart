import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/services/main_model.dart';

import 'global/constant.dart';
import 'global/widgets/navigation_drawer.dart';

class PersonDetails extends StatefulWidget {
  final MainModel model;
  PersonDetails(this.model);

  @override
  _PersonDetailsState createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Me'),
        gradient: Constant.appBarGradient,
      ),
      drawer: NavigationDrawer(model: widget.model),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Orden'),
            subtitle: Text('254'),
          ),
          ListTile(
            title: Text('DNI'),
            subtitle: Text('25.456.484'),
          ),
          ListTile(
            title: Text('Nombre'),
            subtitle: Text('Marcelo Romero'),
          ),
          ListTile(
            title: Text('Dirección'),
            subtitle: Text('Av. Servantes 294'),
          ),
          ListTile(
            title: Text('Voto'),
            subtitle: Text('No'),
          ),
        ],
      ),
    );
  }
}
