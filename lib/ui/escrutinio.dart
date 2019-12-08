import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/scrutiny_category.dart';
import 'package:voting_app/model/scrutiny_party.dart';
import 'package:voting_app/model/vote_election.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'global/utils/constant.dart';
import 'global/utils/text_style_utils.dart';
import 'global/widgets/navigation_drawer.dart';

class Escrutinio extends StatefulWidget {
  final MainModel model;

  Escrutinio(this.model);

  @override
  _EscrutinioState createState() => _EscrutinioState();
}

class _EscrutinioState extends State<Escrutinio> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  CommonWidgest commonWidgest = CommonWidgest();
  String notes = '';

  VoteElection voteElection = VoteElection(quantities: [], notes: "");

  File scrutinyImage;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      scrutinyImage = image;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.model.election == null) loadData();
  }

  Future loadData() async {
    widget.model.fetchElection(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          key: scaffoldKey,
          appBar: GradientAppBar(
            title: Text('Escrutinio'),
            gradient: Constant.appBarGradient,
          ),
          drawer: NavigationDrawer(model: widget.model),
          body: RefreshIndicator(
            onRefresh: loadData,
            child: model.isloadingElection
                ? Center(child: CircularProgressIndicator())
                : (model.election != null)
                    ? Form(
                        key: formKey,
                        child: ListView.builder(
                          itemCount:
                              widget.model.election.scrutinycategories.length +
                                  2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return headerView();
                            } else if (index >=
                                widget.model.election.scrutinycategories
                                        .length +
                                    1) {
                              return footerViewWithNoteAndSubmitButton();
                            } else {
                              return oneCategory(
                                  model.election.scrutinycategories[index - 1]);
                            }
                          },
                        ),
                      )
                    : Center(
                        child: Text("No hay datos de elección"),
                      ),
          ),
        );
      },
    );
  }

  Widget oneCategory(ScrutinyCategory scrutinyCategory) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ExpansionTile(
          key: PageStorageKey<ScrutinyCategory>(scrutinyCategory),
          initiallyExpanded: true,
          title: Text(scrutinyCategory.name),
          children: scrutinyCategory.scrutinyparties
              .map((party) => buildPartyForm(scrutinyCategory, party))
              .toList()),
    );
  }

  Widget buildPartyForm(
      ScrutinyCategory scrutinyCategory, ScrutinyParty party) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(party.name),
          ),
          TextFormField(
            key: PageStorageKey<ScrutinyParty>(party),
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              hintText: "Cantidad: 12",
            ),
            validator: (val) =>
                (val == null) ? 'Ingrese un número válido' : null,
            onChanged: (val) {
              validateVoteForElection(party, val, scrutinyCategory.name);
            },
            // onSaved: (val) {
            //   validateVoteForElection(party, val, scrutinyCategory.name);
            // },
          ),
        ],
      ),
    );
  }

  Widget headerView() {
    return Card(
      margin: EdgeInsets.all(10),
      child: ExpansionTile(
        title: Text(widget.model.election.name),
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text(widget.model.election.description),
          ),
        ],
      ),
    );
  }

  Widget footerViewWithNoteAndSubmitButton() {
    return Column(
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(10),
          child: (scrutinyImage == null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('No hay imagen seleccionada'),
                    ),
                    FlatButton(
                      child: Text("Elegir imagen"),
                      onPressed: () {
                        getImage();
                      },
                    )
                  ],
                )
              : Image.file(
                  scrutinyImage,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Notas",
                hintText: "Hola",
              ),
              maxLines: 10,
              minLines: 5,
              onChanged: (value) => voteElection.notes = value,
              onSaved: (value) => voteElection.notes = value,
            ),
          ),
        ),
        SizedBox(height: 20),
        RaisedButton(
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          child: Text(
            'Enviar',
            style: TextStyleUtils.bottonAndAppBarStyle,
          ),
          onPressed: _submitElectionVote,
        ),
        SizedBox(height: 50),
      ],
    );
  }

  addVote(Vote vote) {
    var existingItem = voteElection.quantities.firstWhere(
        (itemToCheck) => (itemToCheck.scrutinyPartyId == vote.scrutinyPartyId),
        orElse: () => null);
    if (existingItem == null) {
      voteElection.quantities.add(vote);
    } else {
      existingItem.qty = vote.qty;
      voteElection.quantities.remove(existingItem);
      voteElection.quantities.add(vote);
    }
  }

  bool validateAllElectionData() {
    return voteElection.quantities.length == widget.model.numberOfElectionVote;
  }

  void _submitElectionVote() {
    final form = formKey.currentState;
    if (scrutinyImage == null) {
      commonWidgest.showToast("Por favor, seleccionar imagen");
    } else if (form.validate() && validateAllElectionData()) {
      form.save();
      confirmElectionVote();
    } else {
      commonWidgest.showToast(
          "Formulario inválido, revisar los campos. Olvidó cargar campos");
    }
  }

  Future confirmElectionVote() {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: Text("Está seguro que desea enviar la información?"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Si', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                performSubmit();
              },
            ),
            FlatButton(
              child: Text('No', style: TextStyleUtils.dialogButtonTextStyle),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/escrutinio'));
              },
            ),
          ],
        );
      },
    );
  }

  void performSubmit() {
    commonWidgest.progressDialog(context);
    widget.model
        .uploadScrutinyImage(widget.model, scrutinyImage)
        .then((onValue) {
      if (onValue) {
        submitData();
      } else {
        Navigator.popUntil(context, ModalRoute.withName('/escrutinio'));
      }
    }).catchError((onError) {
      Navigator.popUntil(context, ModalRoute.withName('/escrutinio'));
    });
  }

  void submitData() {
    widget.model.submitScrutiny(widget.model, voteElection).then((response) {
      if (response) {
        formKey.currentState?.reset();
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', (Route<dynamic> route) => false);
      } else {
        Navigator.popUntil(context, ModalRoute.withName('/escrutinio'));
      }
    }).catchError((onError) =>
        Navigator.popUntil(context, ModalRoute.withName('/escrutinio')));
  }

  void validateVoteForElection(
      ScrutinyParty party, String val, String categoryName) {
    if (val != null && val.isNotEmpty) {
      addVote(Vote(scrutinyPartyId: party.id, qty: int.parse(val)));
    } else {
      commonWidgest.showToast(
          "Por favor ingrese un número válido para ${party.name} en $categoryName");
    }
  }
}
