import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _nationalId;
  String _password;


  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      print('VALID');
      form.save();
      performSubmit();
    }
  }

  void performSubmit() {
    print('DNI $_nationalId , Password: $_password');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          Container(height: 150.0, width: 150.0,child: Image.asset('assets/logo.png')),
          Padding(padding: const EdgeInsets.only(top:10.0),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Ejemplo: 30123456",
                        labelText: "DNI",
                      ),
                      validator: (val) => !val.contains(RegExp('[0-9]*')) ? 'Sólo números para el DNI.' : null,
                      onSaved: (val) => _nationalId = val,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "", labelText: "Password"),
                      onSaved: (val) => _password = val,
                    ),
                    Padding(padding: const EdgeInsets.only(top: 20.0)),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text('INGRESAR'),
                      onPressed: _submit,
                    ),
                    FlatButton(
                      child: Text(
                        'Registrarse',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {},
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
