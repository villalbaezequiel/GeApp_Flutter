import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/friend.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:voting_app/ui/friend_citizen_details.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';
import 'global/utils/constant.dart';
import 'global/utils/text_style_utils.dart';
import 'global/widgets/navigation_drawer.dart';

class FriendsList extends StatefulWidget {
  final MainModel model;
  FriendsList(this.model);

  FriendsListState createState() => FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  CommonWidgest commonWidgest = CommonWidgest();

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
          body: RefreshIndicator(
            onRefresh: () => model.fetchFriends(model),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: model.isLoadingFriends
                      ? Center(child: CircularProgressIndicator())
                      : (model.friendsList != null &&
                              model.friendsList.length > 0)
                          ? ListView.builder(
                              itemCount: model.friendsCount,
                              itemBuilder: (context, index) {
                                var friend = model.friendsList[index];
                                return friendListItem(friend);
                              },
                            )
                          : Center(child: Text("No hay amigos en tu lista.")),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.grey[200],
                  child: Center(
                    child: model.isLoadingFriends
                        ? Center(child: CircularProgressIndicator())
                        : Text(
                            "Última actualización: " +
                                widget.model.lastFriendListFetchedTime,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleUtils.bottomTimeBar,
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget titleForFriendList() {
    if (widget.model.isLoadingFriends) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Mis Amigos"),
          CircularProgressIndicator(strokeWidth: 1),
        ],
      );
    } else if (widget.model.friendsCount > 0) {
      return Text("Mis Amigos (${widget.model.friendsCount})");
    } else {
      return Text("Mis Amigos");
    }
  }

  Widget friendListItem(Friend friend) {
    return Slidable(
      key: Key(friend.id.toString()),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      closeOnScroll: false,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Eliminar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            confirmDeletion(friend, context);
          },
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
        )),
        child: ListTile(
          title: Text(
              '${friend.citizen.first} ${friend.citizen.last}' /*, style: TextStyle(color: (_person.id==24)?Colors.red:Colors.black),*/),
          subtitle: Text('DNI: ${friend.citizen.nationalId}'),
          // trailing: Text(friend.id.toString()),
          isThreeLine: false,
          dense: false,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => FriendCitizenDetails(friend: friend)),
            );
          },
        ),
      ),
    );
  }

  void deleteFriend(Friend friend) {
    commonWidgest.progressDialog(context);
    widget.model
        .deleteFriend(widget.model, friend)
        .then((onValue) =>
            Navigator.popUntil(context, ModalRoute.withName('/friends_list')))
        .catchError((onError) =>
            Navigator.popUntil(context, ModalRoute.withName('/friends_list')));
  }

  Future confirmDeletion(Friend friend, BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Container(
            child: Text(
              "Está seguro que desea eliminar?",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Si', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                deleteFriend(friend);
              },
            ),
            FlatButton(
              child: Text('No', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/friends_list'));
              },
            ),
          ],
        );
      },
    );
  }
}
