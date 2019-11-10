import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorndial/unicorndial.dart';
import '../model/person.dart';
import 'global/widgets/custom_app_bar.dart';

class MyVotingTableList extends StatefulWidget {
  MyVotingTableState createState() => MyVotingTableState();
}

class MyVotingTableState extends State<MyVotingTableList> {
  List<Person> people = [
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
    final floatingAction = UnicornDialer(
      parentHeroTag: 'vote',
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(
        Icons.add,
        color: Colors.white,
      ),
      childButtons: _getProfileMenu(),
    );

    return Scaffold(
      appBar: CustomAppBar.getAppBar(
        context,
        Row(
          children: <Widget>[Text('Ver Mi Mesa')],
        ),
      ),
      floatingActionButton: floatingAction,
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

  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(
      _profileOption(
        txt: 'Voto',
        iconData: Icons.email,
        onPressed: () {
          _asyncInputDialogVote(context);
        },
      ),
    );
    children.add(
      _profileOption(
        txt: 'Reposición',
        iconData: Icons.library_books,
        onPressed: () {
          _asyncInputDialog(context);
        },
      ),
    );

    return children;
  }

  Future<String> _asyncInputDialogVote(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Voto'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Ingrese el número de orden',
                    hintText: 'ejemplo 154',
                  ),
                  onChanged: (value) {
                    teamName = value;
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reposición de boletas'),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Cantidad boletas repuestas',
                      hintText: 'ejemplo 25'),
                  onChanged: (value) {
                    teamName = value;
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _profileOption({String txt, IconData iconData, Function onPressed}) {
    return UnicornButton(
      labelText: txt,
      labelHasShadow: true,
      labelColor: Theme.of(context).accentColor,
      hasLabel: true,
      currentButton: FloatingActionButton(
        heroTag: txt,
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.white,
        mini: true,
        child: Icon(iconData),
        onPressed: onPressed,
      ),
    );
  }
}

class MyVotingTableListItem extends StatelessWidget {
  final Person _person;

  MyVotingTableListItem(this._person);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          '${_person.name} ${_person.lastname}' /*, style: TextStyle(color: (_person.orderId==24)?Colors.red:Colors.black),*/),
      subtitle: Text('DNI: ${_person.nationalId}'),
      trailing: Text(
          '${_person.orderId}' /*, style: TextStyle(color: (_person.orderId==24)?Colors.red:Colors.black)*/),
      isThreeLine: false,
      dense: false,
      onTap: () {
        print('${_person.name}');
      },
    );
  }
}
