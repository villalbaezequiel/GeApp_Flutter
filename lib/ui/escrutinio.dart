import 'package:flutter/material.dart';

import 'global/widgets/custom_app_bar.dart';

class Escrutinio extends StatelessWidget {
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
