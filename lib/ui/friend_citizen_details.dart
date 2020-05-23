import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/model/friend.dart';

import 'global/utils/constant.dart';

class FriendCitizenDetails extends StatelessWidget {
  final Friend friend;
  FriendCitizenDetails({this.friend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('${friend.citizen.last}'),
        gradient: Constant.appBarGradient,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Nombre y Apellido'),
            subtitle: Text('${friend.citizen.first} ${friend.citizen.last}'),
          ),
          ListTile(
            title: Text('DNI'),
            subtitle: Text('${friend.citizen.nationalId}'),
          ),
          ListTile(
            title: Text('Teléfono'),
            subtitle: Text('${friend.phone}'),
          ),
          ListTile(
            title: Text('Correo electrónico'),
            subtitle: Text('${friend.email}'),
          ),
        ],
      ),
    );
  }
}
