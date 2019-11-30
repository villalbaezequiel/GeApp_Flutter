import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/services/main_model.dart';

import 'global/utils/constant.dart';
import 'global/widgets/navigation_drawer.dart';

class CitizenDetails extends StatefulWidget {
  final MainModel model;
  CitizenDetails(this.model);

  @override
  _CitizenDetailsState createState() => _CitizenDetailsState();
}

class _CitizenDetailsState extends State<CitizenDetails> {
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
