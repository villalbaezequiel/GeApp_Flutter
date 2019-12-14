import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/error.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';

import 'global/utils/constant.dart';
import 'global/widgets/common_widgets.dart';

class SignUp extends StatefulWidget {
  final MainModel model;

  SignUp(this.model);
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String _nationalId; //mandatory
  String _phone; //optional
  String _email; //optional
  String _password; //mandatory
  bool _isChecked = true;
  CommonWidgest commonWidgests = CommonWidgest();

  void _submit() {
    final form = formKey.currentState;
    if (form.validate() && _isChecked == true) {
      form.save();
      performSubmit();
    }
  }

  Future performSubmit() async {
    commonWidgests.progressDialog(context);
    try {
      var params = {
        "nationalId": _nationalId,
        "email": _email,
        "phone": _phone,
        "password": _password,
      };

      var body = json.encode(params);
      final res = await http
          .post(Constant.baseUrl + Constant.createUser, body: body, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
      });

      Navigator.of(context).pop();

      switch (res.statusCode) {
        case 200:
          commonWidgests.showToast("Usuario creado satisfactoriamente ");
          Navigator.of(context).pop();
          break;
        default:
          Map<String, dynamic> mapResponse = json.decode(res.body);
          Errors errors = new Errors.fromJson(mapResponse['errors']);
          commonWidgests.showToast(errors.message);
      }
    } catch (e) {
      if (e is SocketException) {
        commonWidgests.showToast('Sin conexión, por favor intente luego');
      } else {
        commonWidgests.showToast(e.message);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
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
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "",
                            labelText: "Teléfono celular",
                          ),
                          onSaved: (val) => _phone = val,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "",
                            labelText: "Correo electrónico",
                          ),
                          validator: validateEmail,
                          onSaved: (val) => _email = val,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "",
                            labelText: "Contraseña",
                          ),
                          onChanged: (val) => _password = val,
                          onSaved: (val) => _password = val,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "",
                            labelText: "Reingrese contraseña",
                          ),
                          validator: (value) {
                            return (value != _password)
                                ? "La contraseña no coincide"
                                : null;
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  this._isChecked = value;
                                });
                              },
                            ),
                            Flexible(
                              child: FlatButton(
                                onPressed: () {
                                  widget.model.openTermsUrl();
                                },
                                child: Text(
                                  "Aceptar Términos y Condiciones",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: "Helvetica",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: const EdgeInsets.only(top: 20.0)),
                        RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          child: Text(
                            'REGISTRARSE',
                            style: TextStyleUtils.bottonAndAppBarStyle,
                          ),
                          onPressed: _isChecked ? _submit : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String validateEmail(String value) {
    if (value != null && value.isNotEmpty) {
      Pattern pattern =
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
}
