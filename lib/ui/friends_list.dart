import 'package:flutter/material.dart';
import '../model/person.dart';
import 'global/widgets/custom_app_bar.dart';

class FriendsList extends StatefulWidget {
  FriendsListState createState() => FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  List<Person> friends = [
    Person(
        orderId: 124,
        name: 'Rodrigo Martin',
        lastname: 'Weisntein',
        nationalId: '10.252.154'),
    Person(
        orderId: 212,
        name: 'Fernando',
        lastname: 'Mercado',
        nationalId: '12.242.451'),
    Person(
        orderId: 24,
        name: 'Elias Nicolas',
        lastname: 'Jones',
        nationalId: '11.252.854'),
    Person(
        orderId: 5,
        name: 'Geraldine',
        lastname: 'Noel Abadie',
        nationalId: '30.972.154'),
    Person(
        orderId: 54,
        name: 'Fernando',
        lastname: 'Cambareri',
        nationalId: '10.223.782'),
    Person(
        orderId: 87,
        name: 'Gerardo',
        lastname: 'Aguilera',
        nationalId: '20.212.161'),
    Person(
        orderId: 244,
        name: 'Julio',
        lastname: 'Mijoc',
        nationalId: '33.212.256'),
    Person(
        orderId: 213,
        name: 'Rafael',
        lastname: 'Fortunato Cambareri',
        nationalId: '22.263.164'),
    Person(
        orderId: 522,
        name: 'Carlos',
        lastname: 'Gonzalez',
        nationalId: '2.252.144'),
    Person(
        orderId: 553,
        name: 'Arturo',
        lastname: 'Perez',
        nationalId: '31.252.154'),
    Person(
        orderId: 424,
        name: 'Mariano',
        lastname: 'Moreno',
        nationalId: '10.522.162'),
    Person(
        orderId: 3,
        name: 'Santiago',
        lastname: 'Scarcella',
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
            '${_person.name} ${_person.lastname}' /*, style: TextStyle(color: (_person.orderId==24)?Colors.red:Colors.black),*/),
        subtitle: Text('DNI: ${_person.nationalId}'),
        // trailing: Text(
        //     '${_person.orderId}' /*, style: TextStyle(color: (_person.orderId==24)?Colors.red:Colors.black)*/),
        isThreeLine: false,
        dense: false,
        onTap: () {
          print('${_person.name}');
        },
      ),
    );
  }
}
