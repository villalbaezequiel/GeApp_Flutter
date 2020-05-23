import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:voting_app/model/save_request.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  CommonWidgest commonWidgest = CommonWidgest();
  String notes = '';

  File scrutinyImage;

  bool autoValidateForm = false;

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      scrutinyImage = image;
    });
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      scrutinyImage = image;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.model.election == null && !widget.model.isloadingElection)
      loadData();
  }

  Future loadData() async {
    widget.model.fetchElection(widget.model, context);
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
          body: model.isloadingElection
              ? Center(child: CircularProgressIndicator())
              : (model.election != null)
                  ? Form(
                      key: formKey,
                      autovalidate: autoValidateForm,
                      child: ListView.builder(
                        itemCount:
                            widget.model.election.scrutinycategories.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return headerView();
                          } else if (index >=
                              widget.model.election.scrutinycategories.length +
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
        );
      },
    );
  }

  Widget oneCategory(ScrutinyCategory scrutinyCategory) {
    List<Widget> widgetItems = [];
    widgetItems.add(
      Container(
        padding: EdgeInsets.all(10),
        child: Text(
          scrutinyCategory.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    widgetItems.addAll(otherInputsbyParty(scrutinyCategory));
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
      child: Container(
        key: PageStorageKey<ScrutinyCategory>(scrutinyCategory),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetItems,
        ),
      ),
    );
  }

  Widget headerView() {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 3,
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
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: FlatButton.icon(
                      color: Constant.ascent,
                      icon: Icon(Icons.add_a_photo, color: Colors.white),
                      label: Text(
                        'Cámara',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        getImageFromCamera();
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: FlatButton.icon(
                      color: Constant.ascent,
                      icon: Icon(Icons.add_to_photos, color: Colors.white),
                      label: Text(
                        'Galería',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        getImageFromGallery();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                child: (scrutinyImage == null)
                    ? Center(
                        child: Text('No hay imagen seleccionada'),
                      )
                    : Image.file(
                        scrutinyImage,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          elevation: 3,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Notas",
                hintText: "Agregar notas (opcional)",
              ),
              maxLines: 10,
              minLines: 5,
              // onChanged: (value) => voteElection.notes = value,
              onSaved: (value) => widget.model.voteElection.notes = value,
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
    setState(() {
      autoValidateForm = true;
    });
    final form = formKey.currentState;
    form.save();
    bool isFormValid = form.validate();

    if (scrutinyImage == null) {
      commonWidgest.showToast("Por favor, seleccionar imagen");
    } else if (isFormValid) {
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
        .uploadScrutinyImage(widget.model, scrutinyImage, context)
        .then((onValue) {
      if (onValue) {
        submitData();
      } else {
        goToHome();
      }
    }).catchError((onError) {
      if (onError is SocketException) {
        widget.model.updateVotingTableIsOpen(false);
        widget.model.addToSavedRequestsList(
          SaveRequest(
            id: DateTime.now().millisecond,
            url: Constant.scrutinyfile,
            body: widget.model.imageNewFile.path,
            requestType: 'send',
          ),
        );
        submitData();
      }
      goToHome();
    });
  }

  void submitData() {
    widget.model.submitScrutiny(widget.model, context).then((response) {
      if (response) {
        formKey.currentState?.reset();
        goToHome();
      } else {
        goToHome();
      }
    }).catchError(
      (onError) => goToHome(),
    );
  }

  otherInputsbyParty(ScrutinyCategory scrutinyCategory) {
    return scrutinyCategory.scrutinyparties
        .map((party) =>
            PartyInputTextField(widget.model, party, scrutinyCategory))
        .toList();
  }

  goToHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', (Route<dynamic> route) => false);
  }
}

class PartyInputTextField extends StatelessWidget {
  final MainModel model;
  final ScrutinyParty party;
  final ScrutinyCategory scrutinyCategory;

  PartyInputTextField(this.model, this.party, this.scrutinyCategory);

  @override
  Widget build(BuildContext context) {
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
            initialValue: getValue(),
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              hintText: "Cantidad: 12",
            ),
            validator: (val) => (val == null || val.isEmpty)
                ? 'Ingrese un número válido'
                : null,
            onChanged: (val) {
              model.validateVoteForElection(val, party, scrutinyCategory);
            },
          ),
        ],
      ),
    );
  }

  String getValue() {
    if (model.voteElection == null ||
        model.voteElection.quantities.length == 0) {
      return "";
    }
    var existingItem = model.voteElection.quantities.firstWhere(
        (itemToCheck) => (itemToCheck.scrutinyPartyId == party.id),
        orElse: () => null);
    if (existingItem == null) {
      return "";
    } else {
      return existingItem.qty.toString();
    }
  }
}
