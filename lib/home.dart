import 'package:flutter/material.dart';

import 'widgets/drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _size = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amigos ($_size)'),
      ),
      drawer: drawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/AddFriend');
        },
      ),
      body: ListView.builder(
        itemCount: _size,
        itemBuilder: (context, index) {
          return _oneFriend();
        },
      ),
    );
  }

  Widget _oneFriend() {
    return ListTile(
      title: Text('Santosh Sah'),
      subtitle: Text('DNI: 1232323'),
      trailing: Text('12'),
    );
  }
}
