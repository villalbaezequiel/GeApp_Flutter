import 'package:flutter/material.dart';
import '../model/person.dart';
import 'global/widgets/custom_app_bar.dart';

class FriendsList extends StatefulWidget {
  FriendsListState createState() => FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  List<Person> friends = [
    Person(
        id: 124,
        firstName: 'Rodrigo Martin',
        lastName: 'Weisntein',
        nationalId: '10.252.154'),
    Person(
        id: 212,
        firstName: 'Fernando',
        lastName: 'Mercado',
        nationalId: '12.242.451'),
    Person(
        id: 24,
        firstName: 'Elias Nicolas',
        lastName: 'Jones',
        nationalId: '11.252.854'),
    Person(
        id: 5,
        firstName: 'Geraldine',
        lastName: 'Noel Abadie',
        nationalId: '30.972.154'),
    Person(
        id: 54,
        firstName: 'Fernando',
        lastName: 'Cambareri',
        nationalId: '10.223.782'),
    Person(
        id: 87,
        firstName: 'Gerardo',
        lastName: 'Aguilera',
        nationalId: '20.212.161'),
    Person(
        id: 244,
        firstName: 'Julio',
        lastName: 'Mijoc',
        nationalId: '33.212.256'),
    Person(
        id: 213,
        firstName: 'Rafael',
        lastName: 'Fortunato Cambareri',
        nationalId: '22.263.164'),
    Person(
        id: 522,
        firstName: 'Carlos',
        lastName: 'Gonzalez',
        nationalId: '2.252.144'),
    Person(
        id: 553,
        firstName: 'Arturo',
        lastName: 'Perez',
        nationalId: '31.252.154'),
    Person(
        id: 424,
        firstName: 'Mariano',
        lastName: 'Moreno',
        nationalId: '10.522.162'),
    Person(
        id: 3,
        firstName: 'Santiago',
        lastName: 'Scarcella',
        nationalId: '05.732.262')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getAppBar(
        context,
        Row(
          children: <Widget>[Text('Mis Amigos ')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/add_friend'),
        tooltip: 'Agregar Amigo',
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        heroTag: 'add_friend',
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, position) {
          return FriendListItem(friends[position]);
        },
      ),
    );
  }
}

class FriendListItem extends StatelessWidget {
  final Person _person;

  FriendListItem(this._person);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: ListTile(
        title: Text(
            '${_person.firstName} ${_person.lastName}' /*, style: TextStyle(color: (_person.id==24)?Colors.red:Colors.black),*/),
        subtitle: Text('DNI: ${_person.nationalId}'),
        // trailing: Text(
        //     '${_person.id}' /*, style: TextStyle(color: (_person.id==24)?Colors.red:Colors.black)*/),
        isThreeLine: false,
        dense: false,
        onTap: () {
          print('${_person.firstName}');
        },
      ),
    );
  }
}
