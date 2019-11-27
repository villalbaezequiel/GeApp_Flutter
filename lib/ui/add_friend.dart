import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

import 'global/utils/constant.dart';
import 'global/widgets/navigation_drawer.dart';

class AddFriend extends StatefulWidget {
  final MainModel model;
  AddFriend(this.model);

  AddFriendState createState() => AddFriendState();
}

class AddFriendState extends State<AddFriend> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _nationalId;
  String _email;
  String _phoneNumber;

  CommonWidgest commonWidgest = CommonWidgest();

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      performSubmit();
    }
  }

  void performSubmit() async {
    commonWidgest.progressDialog(context);
    await widget.model
        .addFriend(widget.model, _nationalId, _email, _phoneNumber);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Agregar Amigo'),
        gradient: Constant.appBarGradient,
      ),
      drawer: NavigationDrawer(model: widget.model),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Text('El número de DNI del amigo debe estar dentro del padrón. '
                'Los datos de correo electrónico y teléfono son opcionales y solo los verá usted.'),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
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
                        onSaved: (val) => _nationalId = val,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "", labelText: "Correo Electrónico"),
                        onSaved: (val) => _email = val,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            hintText: "+54-911-4567-4567",
                            labelText: "Número de teléfono"),
                        validator: (val) => !val.contains(RegExp(r'[0-9]*'))
                            ? 'Teléfono incorrecto.'
                            : null,
                        onSaved: (val) => _phoneNumber = val,
                      ),
                      Padding(padding: const EdgeInsets.only(top: 20.0)),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        child: Text(
                          'AGREGAR',
                          style: TextStyleUtils.bottonAndAppBarStyle,
                        ),
                        onPressed: _submit,
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
