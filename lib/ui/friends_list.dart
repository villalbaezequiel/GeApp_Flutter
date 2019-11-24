import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/services/main_model.dart';

import '../model/person.dart';
import 'global/constant.dart';
import 'global/utils/text_style_utils.dart';
import 'global/widgets/navigation_drawer.dart';

class FriendsList extends StatefulWidget {
  final MainModel model;
  FriendsList(this.model);

  FriendsListState createState() => FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  @override
  void initState() {
    super.initState();
    if (widget.model.friendsCount == 0) loadFriends();
  }

  Future loadFriends() async {
    widget.model.fetchFriends(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: GradientAppBar(
            title: titleForFriendList(),
            gradient: Constant.appBarGradient,
          ),
          drawer: NavigationDrawer(model: model),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add_friend');
            },
            tooltip: 'Agregar Amigo',
            child: Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            heroTag: 'add_friend',
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: model.isLoadingFriends
                    ? Center(child: CircularProgressIndicator())
                    : (model.friendsList.length > 0)
                        ? RefreshIndicator(
                            onRefresh: () => model.fetchFriends(model),
                            child: ListView.builder(
                              itemCount: model.friendsCount,
                              itemBuilder: (context, index) {
                                var friend = model.friendsList[index];
                                return friendListItem(friend);
                              },
                            ),
                          )
                        : Center(
                            child: Text("There are no friends in your list.")),
              ),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    "Última actualización: 23:15 24/05/19",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleUtils.bottomTimeBar,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget titleForFriendList() {
    int friendsCount = widget.model.friendsCount;
    return (friendsCount > 0)
        ? Text("Mis Amigos ($friendsCount)")
        : Text("Mis Amigos");
  }

  Widget friendListItem(Person person) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: ListTile(
        title: Text(
            '${person.firstName} ${person.lastName}' /*, style: TextStyle(color: (_person.id==24)?Colors.red:Colors.black),*/),
        subtitle: Text('DNI: ${person.nationalId}'),
        // trailing: Text(
        //     '${_person.id}' /*, style: TextStyle(color: (_person.id==24)?Colors.red:Colors.black)*/),
        isThreeLine: false,
        dense: false,
        onTap: () {
          print('${person.firstName}');
        },
      ),
    );
  }
}
