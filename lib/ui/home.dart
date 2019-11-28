import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/global/widgets/navigation_drawer.dart';

import 'global/utils/constant.dart';

class Home extends StatefulWidget {
  final MainModel model;
  Home(this.model);
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    widget.model.fetchFriends(widget.model);
    widget.model.fetchVotingTable(widget.model);
    // TODO: call election api
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return new Scaffold(
          appBar: GradientAppBar(
            title: Text('Inicio'),
            gradient: Constant.appBarGradient,
          ),
          drawer: NavigationDrawer(model: widget.model),
          backgroundColor: Colors.white,
          // floatingActionButton: floatingAction,
          body: ListView(
            children: <Widget>[
              Image.asset(
                'assets/images/logo2.png',
                height: 150,
              ),
              SizedBox(height: 30),
              homeButton('Agregar amigo', '/add_friend', Icons.person_add),
              homeButton('Mis amigos', '/friends_list', Icons.group),
              homeButton('Mi mesa', '/my_voting_table_list', Icons.list),
              homeButton('Escrutinio', '/escrutinio', Icons.check_circle),
              homeButton('Ayuda', '/help', Icons.help_outline),
              SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Container homeButton(String title, String path, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        gradient: Constant.gradient,
        borderRadius: BorderRadius.circular(2),
      ),
      child: ListTile(
        enabled: widget.model.checkDiability(path),
        onTap: () {
          navigateToPath(path);
        },
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: TextStyleUtils.bottonAndAppBarStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToPath(String path) {
    if (path == "/help") {
      widget.model.openWhatsApp(widget.model);
    } else {
      Navigator.of(context).pushNamed(path);
    }
  }
}
