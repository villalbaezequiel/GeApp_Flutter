import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/scrutiny_category.dart';
import 'package:voting_app/model/scrutiny_party.dart';
import 'package:voting_app/services/main_model.dart';
import 'package:voting_app/ui/global/widgets/common_widgets.dart';

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
  @override
  void initState() {
    super.initState();
    if (widget.model.election == null) loadData();
  }

  Future loadData() async {
    widget.model.fetchElection(widget.model);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  CommonWidgest commonWidgest = CommonWidgest();
  String notes = '';

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
                        child: Text("No election data."),
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
              .map((party) =>
                  buildPartyForm(scrutinyCategory.scrutinyparties[0]))
              .toList()),
    );
  }

  Widget buildPartyForm(ScrutinyParty party) {
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
            autovalidate: true,
            validator: (val) =>
                (val == null) ? 'Please input valid number' : null,
            // onSaved: (val) => _nationalId = val,
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
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Notas",
                hintText: "Hello",
              ),
              maxLines: 10,
              minLines: 5,
              onSaved: (value) => notes = value,
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

  void _submitElectionVote() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      // performSubmit();
    }
  }

  void performSubmit() {
    commonWidgest.progressDialog(context);
    widget.model.submitScrutiny(widget.model, notes).then((onValue) {
      Navigator.of(context).pop();
      formKey.currentState?.reset();
    }).catchError((onError) => Navigator.of(context).pop());
  }
}
