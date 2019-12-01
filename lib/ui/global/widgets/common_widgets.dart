import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/constant.dart';

class CommonWidgest {
  Future progressDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Procesando el pedido"),
              SizedBox(
                height: 20.0,
              ),
              CircularProgressIndicator(
                backgroundColor: Constant.ascent,
                value: null,
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            ],
          ),
        );
      },
    );
  }

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
