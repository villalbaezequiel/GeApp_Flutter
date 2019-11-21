import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonWidgest {
  Future progressDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text("Procesando el pedido"),
                SizedBox(
                  height: 20.0,
                ),
                CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
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
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
