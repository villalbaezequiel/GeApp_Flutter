import 'package:flutter/material.dart';
import 'package:voting_app/services/main_model.dart';

import 'global/widgets/custom_app_bar.dart';

class Escrutinio extends StatefulWidget {
  final MainModel model;

  Escrutinio(this.model);

  @override
  _EscrutinioState createState() => _EscrutinioState();
}

class _EscrutinioState extends State<Escrutinio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getAppBar(
        context,
        Row(
          children: <Widget>[Text('Escrutinio')],
        ),
      ),
      body: Center(
        child: Text('Escrutinio'),
      ),
    );
  }
}
