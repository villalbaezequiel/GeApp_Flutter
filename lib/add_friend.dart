import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adherir'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
                "I would be great if get this project. Give me a chance to apolige. I would be great if get this project. Give me a chance to apolige. I would be great if get this project. Give me a chance to apolige."),
          )
        ],
      ),
    );
  }
}
