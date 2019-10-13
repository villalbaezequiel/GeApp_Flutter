import 'package:flutter/material.dart';

import 'global/widgets/custom_app_bar.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getAppBar('Ayuda', context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Su whatsapp de contacto es: ',
            style: TextStyle(fontSize: 20.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.phone, color: Colors.green),
              Text('+54-911-4657-4567', style: TextStyle(fontSize: 30.0)),
            ],
          ),
        ],
      ),
    );
  }
}
