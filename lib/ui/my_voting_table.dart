import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/voter.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/utils/text_style_utils.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';
import 'package:voting_app/ui/voter_citizen_details.dart';

import 'global/utils/constant.dart';
import 'global/widgets/fab.dart';
import 'global/widgets/navigation_drawer.dart';

class MyVotingTableList extends StatefulWidget {
  final MainModel model;
  MyVotingTableList(this.model);

  MyVotingTableState createState() => MyVotingTableState();
}

class MyVotingTableState extends State<MyVotingTableList>
    with SingleTickerProviderStateMixin {
  CommonWidgest commonWidgest = CommonWidgest();
  int currentItemIndex = 0;
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _controller);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    if (widget.model.votingTable == null && !widget.model.isloadingVotingTable)
      loadVotingTable();

    super.initState();
  }

  Future loadVotingTable() async {
    widget.model.fetchVotingTable(widget.model, context);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: GradientAppBar(
            title: titleForVotingTable(),
            gradient: Constant.appBarGradient,
          ),
          drawer: NavigationDrawer(model: widget.model),
          floatingActionButton: ExpandedAnimationFab(
            items: [
              FabItem(
                "Voto",
                Icons.email,
                onPress: () {
                  _asyncInputDialogVote(context);
                  _controller.reverse();
                },
              ),
              FabItem(
                "Reposición",
                Icons.library_books,
                onPress: () {
                  _asyncInputDialogReplenish(context);

                  _controller.reverse();
                },
              ),
            ],
            animation: _animation,
            onPress: () {
              if (_controller.isCompleted) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
            },
          ),
          body: RefreshIndicator(
            onRefresh: () =>
                widget.model.fetchVotingTable(widget.model, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: widget.model.isloadingVotingTable
                      ? Center(child: CircularProgressIndicator())
                      : (widget.model.votingTable != null &&
                              widget.model.votingTable.voters.length > 0)
                          ? Container(
                              child: buildVoters(),
                            )
                          : Center(child: Text("No hay votantes")),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 5),
                  color: Colors.grey[200],
                  width: double.infinity,
                  child: widget.model.isloadingVotingTable
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "Última actualización: " +
                              widget.model.lastVotingTableFetchedTime,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleUtils.bottomTimeBar,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildVoters() {
    int totalLength = widget.model.votingTable.voters.length + 1;
    return ListView.builder(
      itemCount: totalLength,
      itemBuilder: (context, index) {
        if (index >= widget.model.votingTable.voters.length) {
          return Container(height: 50);
        } else {
          var voter = widget.model.votingTable.voters[index];
          return voterListItem(voter);
        }
      },
    );
  }

  Future<String> _asyncInputDialogVote(BuildContext context) async {
    int orderNumber;
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
                    labelText: 'Número de orden',
                    hintText: 'Ejemplo 154',
                  ),
                  onChanged: (value) {
                    orderNumber = int.parse(value);
                  },
                  onSubmitted: (value) => orderNumber = int.parse(value),
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
                  commonWidgest.showToast(
                      'Número de orden no encontrado o ya ha votado');
                }
                // Navigator.of(context).pop(teamName);
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

  Future<String> _asyncInputDialogReplenish(BuildContext context) async {
    bool validateReplesh = false;
    final repleshFormKey = GlobalKey<FormState>();
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
                child: Form(
                  autovalidate: validateReplesh,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Cantidad boletas repuestas',
                        hintText: 'ejemplo 25'),
                    validator: validateRepleshForm,
                    onSaved: (value) {
                      teamName = value;
                    },
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                setState(() {
                  validateReplesh = true;
                });
                final repleshForm = repleshFormKey.currentState;
                repleshForm.save();
                if (repleshForm.validate()) {
                  callAprForReplenish(teamName);
                }
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

  String validateRepleshForm(String value) {
    if (value == null || value.isEmpty) {
      return "Please enter value";
    } else {
      return null;
    }
  }

  Widget titleForVotingTable() {
    if (widget.model.isVotingOrReplenish || widget.model.isloadingVotingTable) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Mi Mesa"),
          CircularProgressIndicator(strokeWidth: 1),
        ],
      );
    } else if (widget.model.votingTable != null) {
      return Text(
          "Mi Mesa (${widget.model.votingTable.sumVotes}/${widget.model.votingTable.voters.length})");
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
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: (voter.voted)
                ? Icon(Icons.brightness_1, color: Colors.green, size: 14)
                : Icon(Icons.brightness_low,
                    color: Colors.transparent, size: 14),
          ),
          Expanded(
            child: ListTile(
              title: Text('${voter.citizen.first} ${voter.citizen.last}'),
              subtitle: Text('DNI: ${voter.citizen.nationalId}'),
              trailing: Text(voter.order.toString()),
              isThreeLine: false,
              dense: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoterCitizenDetails(
                      model: widget.model,
                      voter: voter,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
          title: Text('Confirmar voto'),
          content: Container(
            child: Text(
              "¿Votó ${voter.citizen.first.toString()} ${voter.citizen.last.toString()} , nro de orden: ${voter.order}?",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Si', style: TextStyleUtils.dialogButtonTextStyle),
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

  void callAprForReplenish(String quantity) {
    commonWidgest.progressDialog(context);
    widget.model
        .replenishVote(widget.model, int.parse(quantity), context)
        .then((onValue) {
      Navigator.popUntil(context, ModalRoute.withName('/my_voting_table_list'));
    }).catchError((onError) {
      Navigator.popUntil(context, ModalRoute.withName('/my_voting_table_list'));
    });
  }

  void callApiForVote(Voter voter) {
    commonWidgest.progressDialog(context);
    widget.model.vote(widget.model, voter, context).then((onValue) {
      Navigator.popUntil(context, ModalRoute.withName('/my_voting_table_list'));
      buildVoters();
      commonWidgest.showToast("Voto registrado correctamente");
    }).catchError((onError) {
      Navigator.popUntil(context, ModalRoute.withName('/my_voting_table_list'));
    });
  }
}
