import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/services/main_model.dart';

import 'global/utils/constant.dart';
import 'global/widgets/navigation_drawer.dart';

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
      appBar: GradientAppBar(
        title: Text('Escrutinio'),
        gradient: Constant.appBarGradient,
      ),
      drawer: NavigationDrawer(model: widget.model),
      body: Center(
        child: Text('Escrutinio'),
      ),
    );
  }
}
