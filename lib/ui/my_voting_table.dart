import 'package:flutter/material.dart';
import '../model/person.dart';
import 'global/widgets/custom_app_bar.dart';

class MyVotingTableList extends StatefulWidget {
  MyVotingTableState createState() => MyVotingTableState();
}

class MyVotingTableState extends State<MyVotingTableList> {
  List<Person> people = [
    new Person(
        orderId: 124,
        name: 'Rodrigo Martin',
        lastname: 'Weisntein',
        nationalId: '10.252.154'),
    new Person(
        orderId: 212,
        name: 'Fernando',
        lastname: 'Mercado',
        nationalId: '12.242.451'),
    new Person(
        orderId: 24,
        name: 'Elias Nicolas',
        lastname: 'Jones',
        nationalId: '11.252.854'),
    new Person(
        orderId: 5,
        name: 'Geraldine',
        lastname: 'Noel Abadie',
        nationalId: '30.972.154'),
    new Person(
        orderId: 54,
        name: 'Fernando',
        lastname: 'Cambareri',
        nationalId: '10.223.782'),
    new Person(
        orderId: 87,
        name: 'Gerardo',
        lastname: 'Aguilera',
        nationalId: '20.212.161'),
    new Person(
        orderId: 244,
        name: 'Julio',
        lastname: 'Mijoc',
        nationalId: '33.212.256'),
    new Person(
        orderId: 213,
        name: 'Rafael',
        lastname: 'Fortunato Cambareri',
        nationalId: '22.263.164'),
    new Person(
        orderId: 522,
        name: 'Carlos',
        lastname: 'Gonzalez',
        nationalId: '2.252.144'),
    new Person(
        orderId: 553,
        name: 'Arturo',
        lastname: 'Perez',
        nationalId: '31.252.154'),
    new Person(
        orderId: 424,
        name: 'Mariano',
        lastname: 'Moreno',
        nationalId: '10.522.162'),
    new Person(
        orderId: 3,
        name: 'Santiago',
        lastname: 'Scarcella',
        nationalId: '05.732.262')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.getAppBar('Ver Mi Mesa', context),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
        ),
        itemCount: people.length,
        itemBuilder: (context, position) {
          return MyVotingTableListItem(people[position]);
        },
      ),
    );
  }
}

class MyVotingTableListItem extends StatelessWidget {
  final Person _person;

  MyVotingTableListItem(this._person);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('${_person.name}');
      },
      child: ListTile(
        title: Text(
            '${_person.name} ${_person.lastname}' /*, style: TextStyle(color: (_person.orderId==24)?Colors.red:Colors.black),*/),
        subtitle: Text('DNI: ${_person.nationalId}'),
        trailing: Text(
            '${_person.orderId}' /*, style: TextStyle(color: (_person.orderId==24)?Colors.red:Colors.black)*/),
        isThreeLine: false,
        dense: false,
      ),
    );
  }
}
