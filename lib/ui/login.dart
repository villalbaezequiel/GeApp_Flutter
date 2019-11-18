import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/model/person.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

import 'global/constant.dart';
import 'home.dart';

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _nationalId;
  String _password;

  CommonWidgest commonWidgests = CommonWidgest();

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      print('VALID');
      form.save();
      performSubmit();
    }
  }

  void performSubmit() async {
    commonWidgests.progressDialog(context);
    try {
      var params = {
        "nationalId": _nationalId,
        "password": _password,
      };

      var body = json.encode(params);
      final res = await http
          .post(Constant.baseUrl + Constant.login, body: body, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      });

      Navigator.of(context).pop();

      switch (res.statusCode) {
        case 200:
          Map<String, dynamic> mapResponse = json.decode(res.body);
          Person user = Person.fromJson(mapResponse);
          await user.savePersonToSharedPref(json.encode(user));
          _goToHome(user);
          break;
        case 401:
          commonWidgests.showToast("DNI o contraseña invalida");
          break;
        default:
          Map<String, dynamic> mapResponse = json.decode(res.body);
          Errors errors = new Errors.fromJson(mapResponse['errors']);
          commonWidgests.showToast(errors.message);
      }
    } catch (e) {
      commonWidgests.showToast(e.message);
      Navigator.pop(context);
    }
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
                margin: EdgeInsets.symmetric(vertical: 30),
                height: 150.0,
                width: 150.0,
                child: Image.asset('assets/images/logo2.png')),
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
                        hintText: "Ejemplo: 30123456",
                        labelText: "DNI",
                      ),
                      validator: (val) => !val.contains(RegExp('[0-9]*'))
                          ? 'Sólo números para el DNI.'
                          : null,
                      onSaved: (val) => _nationalId = val,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "",
                        labelText: "Password",
                      ),
                      onSaved: (val) => _password = val,
                    ),
                    Padding(padding: const EdgeInsets.only(top: 20.0)),
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      child: Text('INGRESAR'),
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
            FlatButton(
              child: Text(
                'Registrarse',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/sign_up");
              },
            )
          ],
        ),
      ),
    );
  }

  void _goToHome(Person user) {
    commonWidgests.showToast("Sucessfully logged in");
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(
            user: user,
          ),
        ),
        (Route<dynamic> route) => false);
  }
}
