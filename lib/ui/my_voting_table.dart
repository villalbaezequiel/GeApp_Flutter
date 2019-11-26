import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:voting_app/model/voter.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';
import 'global/constant.dart';
import 'global/widgets/navigation_drawer.dart';

class MyVotingTableList extends StatefulWidget {
  final MainModel model;
  MyVotingTableList(this.model);

  MyVotingTableState createState() => MyVotingTableState();
}

class MyVotingTableState extends State<MyVotingTableList> {
  CommonWidgest commonWidgest = CommonWidgest();

  @override
  void initState() {
    super.initState();
    if (widget.model.votingTable == null) loadVotingTable();
  }

  Future loadVotingTable() async {
    widget.model.fetchVotingTable(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final floatingAction = UnicornDialer(
      parentHeroTag: 'vote_parent',
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: _getFloatingButtons(),
    );

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: GradientAppBar(
            title: titleForVotingTable(),
            gradient: Constant.appBarGradient,
          ),
          drawer: NavigationDrawer(model: widget.model),
          floatingActionButton: floatingAction,
          // body: ListView.separated(
          //   separatorBuilder: (context, index) => Divider(
          //     color: Colors.grey,
          //   ),
          //   itemCount: people.length,
          //   itemBuilder: (context, position) {
          //     return MyVotingTableListItem(people[position]);
          //   },
          // ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: widget.model.isloadingVotingTable
                    ? Center(child: CircularProgressIndicator())
                    : (widget.model.votingTable.voters.length > 0)
                        ? RefreshIndicator(
                            onRefresh: () =>
                                widget.model.fetchVotingTable(widget.model),
                            child: ListView.builder(
                              itemCount: widget.model.votingTable.voters.length,
                              itemBuilder: (context, index) {
                                var voter =
                                    widget.model.votingTable.voters[index];
                                return voterListItem(voter);
                              },
                            ),
                          )
                        : Center(child: Text("No voters")),
              ),
              Container(
                padding: EdgeInsets.all(5),
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

  List<UnicornButton> _getFloatingButtons() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(
      _floatingButtons(
        txt: 'Voto',
        iconData: Icons.email,
        onPressed: () {
          _asyncInputDialogVote(context);
        },
      ),
    );
    children.add(
      _floatingButtons(
        txt: 'Reposición',
        iconData: Icons.library_books,
        onPressed: () {
          _asyncInputDialogReplenish(context);
        },
      ),
    );

    return children;
  }

  Future<String> _asyncInputDialogVote(BuildContext context) async {
    String orderNumber = '';
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
                    orderNumber = value;
                  },
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                Voter voter = widget.model.validateVoterOrder(orderNumber);
                if (voter != null) {
                  showConfirmationDialog(voter, context);
                } else {
                  commonWidgest.showToast('Nro de orden no encontrado');
                }
                // Navigator.of(context).pop(teamName);
              },
            ),
            FlatButton(
              child:
                  Text('Cancelar', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                Navigator.of(context).pop(orderNumber);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _asyncInputDialogReplenish(BuildContext context) async {
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
              child: Text('Ok', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                callAprForReplenish(teamName);
              },
            ),
            FlatButton(
              child:
                  Text('Cancelar', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _floatingButtons({String txt, IconData iconData, Function onPressed}) {
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

  Widget titleForVotingTable() {
    if (widget.model.votingTable != null) {
      return Text("Mi Mesa (${widget.model.votingTable.sumVotes})");
    } else {
      return Text("Mi Mesa");
    }
  }

  Widget voterListItem(Voter voter) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
      )),
      child: ListTile(
        title: Text(
            '${voter.citizen.first} ${voter.citizen.last}' /*, style: TextStyle(color: (_person.id==24)?Colors.red:Colors.black),*/),
        subtitle: Text('DNI: ${voter.citizen.nationalId}'),
        trailing: Text(voter.order.toString()),
        isThreeLine: false,
        dense: false,
        leading: (voter.voted)
            ? Icon(Icons.brightness_1, color: Colors.green, size: 14)
            : Icon(Icons.brightness_low, color: Colors.transparent, size: 14),
        onTap: () {
          print('${voter.citizen.first}');
        },
      ),
    );
  }

  Future showConfirmationDialog(Voter voter, BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reposición de boletas'),
          content: Container(
            child: Text(
              "¿Votó ${voter.citizen.first.toString()} ${voter.citizen.last.toString()} , nro de orden: ${voter.order}?",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                callApiForVote(voter);
              },
            ),
            FlatButton(
              child: Text('No', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName('/my_voting_table_list'));
              },
            ),
          ],
        );
      },
    );
  }

  void callAprForReplenish(String quantity) async {
    commonWidgest.progressDialog(context);
    await widget.model.replenishVote(widget.model, int.parse(quantity));
    Navigator.popUntil(context, ModalRoute.withName('/my_voting_table_list'));
  }

  void callApiForVote(Voter voter) async {
    commonWidgest.progressDialog(context);
    await widget.model.vote(widget.model, voter);
    Navigator.popUntil(context, ModalRoute.withName('/my_voting_table_list'));
  }
}
