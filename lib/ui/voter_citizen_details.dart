import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/model/voter.dart';
import 'package:voting_app/services/main_model.dart';

import 'global/utils/constant.dart';

class VoterCitizenDetails extends StatelessWidget {
  final MainModel model;
  final Voter voter;

  VoterCitizenDetails({this.model, this.voter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(voter.citizen.last),
        gradient: Constant.appBarGradient,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Nombre y Apellido'),
            subtitle: Text('${voter.citizen.first} ${voter.citizen.last}'),
          ),
          ListTile(
            title: Text('Edad'),
            subtitle: Text('${voter.citizen.age}'),
          ),
          ListTile(
            title: Text('DNI'),
            subtitle: Text('${voter.citizen.nationalId}'),
          ),
          ListTile(
            title: Text('Dirección'),
            subtitle: Text('${model.votingTable.address}'),
          ),
          ListTile(
            title: Text('Establecimiento'),
            subtitle: Text('${model.votingTable.establishment}'),
          ),
          ListTile(
            title: Text('Sección'),
            subtitle: Text('${model.votingTable.section}'),
          ),
          ListTile(
            title: Text('Circuito'),
            subtitle: Text('${model.votingTable.circuit}'),
          ),
          ListTile(
            title: Text('Distrito'),
            subtitle: Text('${model.votingTable.district}'),
          ),
          ListTile(
            title: Text('Mesa'),
            subtitle: Text('${model.votingTable.table}'),
          ),
          ListTile(
            title: Text('Orden'),
            subtitle: Text('${voter.order}'),
          ),
        ],
      ),
    );
  }
}
