import 'package:flutter/material.dart';

class Help extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Su whatsapp de contacto es: ', style: TextStyle(fontSize: 20.0),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Icon(Icons.phone,color:  Colors.green,),
            Text('+54-911-4657-4567',style: TextStyle(fontSize: 30.0))
          ],),
        ],
    );
  }
}