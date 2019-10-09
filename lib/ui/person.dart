import 'package:flutter/material.dart';

class PersonDetails extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Romero'),),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text('Orden'), subtitle: Text('254'),),
          ListTile(title: Text('DNI'), subtitle: Text('25.456.484'),),
          ListTile(title: Text('Nombre'), subtitle: Text('Marcelo Romero'),),
          ListTile(title: Text('Dirección'), subtitle: Text('Av. Servantes 294'),),
          ListTile(title: Text('Voto'), subtitle: Text('No'),),
        ],
      ),);

  }

}