import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voting_app/ui/global/gradient_app_bar.dart';
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
  late String _nationalId;
  late String _email;
  late String _phoneNumber;

  CommonWidgest commonWidgest = CommonWidgest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('Agregar Amigo'),
        gradient: Constant.appBarGradient,
      ),
      drawer: AppNavigationDrawer(model: widget.model),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            // SizedBox(height: 10),
            Text(
              'El número de DNI del amigo debe estar dentro del padrón. '
              'Los datos de correo electrónico y teléfono son opcionales y solo los verá usted.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Container(
              // padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: "Ejemplo: 30154487",
                        labelText: "DNI",
                      ),
                      validator: (val) => !val!.contains(RegExp('[0-9]*'))
                          ? 'Sólo números para el DNI.'
                          : null,
                      onSaved: (val) => _nationalId = val!,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: "+54-911-4567-4567",
                          labelText: "Número de teléfono"),
                      validator: (val) => !val!.contains(RegExp(r'[0-9]*'))
                          ? 'Teléfono incorrecto.'
                          : null,
                      onSaved: (val) => _phoneNumber = val!,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "",
                        labelText: "Correo Electrónico",
                      ),
                      validator: validateEmail,
                      onSaved: (val) => _email = val!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white),
                      child: Text(
                        'AGREGAR',
                        style: TextStyleUtils.bottonAndAppBarStyle,
                      ),
                      onPressed: _submit,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Ingrese correo válido';
      else
        return null;
    } else {
      return null;
    }
  }

  void _submit() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form!.save();
      performSubmit();
    }
  }

  void performSubmit() {
    commonWidgest.progressDialog(context);
    widget.model
        .addFriend(widget.model, _nationalId, _email, _phoneNumber, context)
        .then((onValue) {
      Navigator.of(context).pop();
      formKey.currentState?.reset();
    }).catchError((onError) => Navigator.of(context).pop());
  }
}
