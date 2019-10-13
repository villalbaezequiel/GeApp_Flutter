import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _nationalId; //mandatory
  String _phone; //optional
  String _email; //optional
  String _password; //mandatory
  String _rePassword; //mandatory

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      print('VALID');
      form.save();
      performSubmit();
    }
  }

  void performSubmit() {
    print(
        'DNI $_nationalId , Password: $_password , Re-Password: $_rePassword , Phone: $_phone , Email: $_email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 150.0,
              width: 150.0,
              child: Image.asset('assets/images/logo2.png'),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 10),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Ejemplo: 30123456",
                        labelText: "DNI",
                      ),
                      validator: (val) => !val.contains(RegExp('[0-9]*'))
                          ? 'Sólo números para el DNI.'
                          : null,
                      onSaved: (val) => _nationalId = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "", labelText: "Teléfono celular"),
                      onSaved: (val) => _phone = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "", labelText: "Correo electrónico"),
                      onSaved: (val) => _email = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "", labelText: "Contraseña"),
                      onSaved: (val) => _password = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "", labelText: "Reingrese contraseña"),
                      onSaved: (val) => _rePassword = val,
                    ),
                    Padding(padding: const EdgeInsets.only(top: 20.0)),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text('REGISTRARSE'),
                      onPressed: /*_submit*/ () {
                        _asyncInputDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Usuario creado correctamente'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: Text(
                    'Se deberá aprobar el usuario para poder comenzar a usar la aplicación.'),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }
}
