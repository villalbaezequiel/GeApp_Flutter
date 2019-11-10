import 'package:flutter/material.dart';

import 'global/widgets/custom_app_bar.dart';

class PersonDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getAppBar(
          context,
          Row(
            children: <Widget>[Text('Me')],
          )),
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
