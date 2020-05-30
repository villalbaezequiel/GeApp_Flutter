import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/model/scpl_client.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

import 'global/utils/constant.dart';

class ScplAvalClient extends StatelessWidget {
  final MainModel model;
  final ScplClient client;

  ScplAvalClient({this.model, this.client});

  CommonWidgest commonWidgests = CommonWidgest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('${client.nameLastname}'),
        gradient: Constant.appBarGradient,
      ),
      body: ListView(
        children: <Widget>[

          ListTile(
            title: Text('DNI'),
            subtitle: Text('${client.dni}'),
          ),
          ListTile(
            title: Text('Nombre y Apellido'),
            subtitle: Text('${client.nameLastname}'),
          ),
          ListTile(
            title: Text('Número de Sección Electoral'),
            subtitle: Text('${client.electroral}'),
          ),
          ListTile(
            title: Text('Número de Socio'),
            subtitle: Text('${client.partner}'),
          ),
          ListTile(
            title: Text('Domicilio'),
            subtitle: Text('${client.address} ${client.addressNumber}'),
          ),
          Container(
            child: Center(
              child: isFirmoAval(context, client.isSigned),
            ),
          ),
        ],
      ),
    );
  }

  Widget isFirmoAval(context, isSigned){
    if(isSigned == null){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '¿Firmó el Aval?',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Text('SI', style: TextStyleUtils.bottonAndAppBarStyle),
                    onPressed: () {
                      firmarAval('${client.id}', context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.red,
                    child: Text('NO', style: TextStyle(fontSize: 18)),
                    onPressed: () {
                      commonWidgests.showToast('No se registró la Firma!');
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ]
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '¡Firma Registrada!',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      );
    }
  }

  void firmarAval(id, context)
  {
    model.avalClient(model, id, context)
    .then((onValue) {
      if(onValue != null) {
        commonWidgests.showToast('Firma registrada con Exito!');
        Navigator.of(context).pop();
      } else {
        Navigator.pushNamedAndRemoveUntil(
        context, '/scpl/fetch_client', (Route<dynamic> route) => false);
      }
    }).catchError((onError) => Navigator.of(context).pop());

  }

}
