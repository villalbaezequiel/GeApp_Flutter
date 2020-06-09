import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/model/scpl_client.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';
import 'package:voting_app/ui/scpl_client_aval.dart';

import 'global/utils/constant.dart';
import 'global/widgets/navigation_drawer.dart';

class ScplFetchClient extends StatefulWidget {

  final MainModel model;
  ScplFetchClient(this.model);

  ScplFetchClientForm createState() => ScplFetchClientForm();

}

class ScplFetchClientForm extends State<ScplFetchClient> {

  final formKey     = GlobalKey<FormState>();
  String dni;

  CommonWidgest commonWidgests = CommonWidgest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Consulta de Distrito'),
        gradient: Constant.appBarGradient,
      ),
      drawer: NavigationDrawer(model: widget.model),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Ingrese DNI del titular del Medidor',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "Ejemplo: 30154487",
                        labelText: "DNI",
                      ),
                      validator: (val) => !val.contains(RegExp('[0-9]*'))
                          ? 'Sólo números para el DNI.'
                          : null,
                      onSaved: (val) => dni = val,
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text(
                        'CONSULTAR',
                        style: TextStyleUtils.bottonAndAppBarStyle,
                      ),
                      onPressed: () {
                        _submit();
                      },
                    )
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit()
  {
    final form = formKey.currentState;
    if(form.validate())
    {
      form.save();
      performSubmit();
    }
  }

  void performSubmit()
  {
    widget.model
    .fetchClient(widget.model, dni, context)
    .then((onValue) {
      if(onValue != null) {
        getDetailsClientAval(context, onValue);
        formKey.currentState?.reset();
      } else {
        commonWidgests.showToast('Titular no encontrado!');
        Navigator.pushNamedAndRemoveUntil(
            context, '/scpl/fetch_client', (Route<dynamic> route) => false);
      }
    }).catchError((onError) => Navigator.of(context).pop());
  }

  void getDetailsClientAval(BuildContext context, client) async {
    await Navigator.push(
      context, MaterialPageRoute(builder: (context) => ScplAvalClient(model: widget.model, client: client)),
    );
  }

}
