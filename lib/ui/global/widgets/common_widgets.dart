import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant.dart';

class CommonWidgest {
  Future progressDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 80.0,
            alignment: Alignment.center,
            // padding: EdgeInsets.all(10.0),
            child: Column(
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
      backgroundColor: Constant.ascent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
