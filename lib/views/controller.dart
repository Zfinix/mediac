import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediac/functions/api.dart';
import 'package:mediac/models/NLPModel.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/models/submitSymptoms.dart';
import 'package:mediac/utils/date.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/utils/persistence.dart';
import 'package:mediac/utils/url.dart';
import 'package:mediac/views/symptoms.dart';

import 'diagnosis.dart';

class Controller extends StatefulWidget {
  const Controller({Key key, @required this.changeView, this.userModel})
      : super(key: key);

  final UserModel userModel;

  final Function changeView;

  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  bool isLoading = false;
  String nLPText = '';

  Widget _appBarTitle;
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);

  @override
  void initState() {
    datax();
    super.initState();
  }

  Container startButton() {
    return Container(
      width: 200,
      child: OutlineButton(
        highlightColor: Colors.white24,
        color: Colors.blue,
        textColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          if (widget.userModel != null)
            this.widget.changeView(Symptoms(
                  changeView: this.widget.changeView,
                  userModel: widget.userModel,
                ));
          else
            datax();
        },
        child: Text(
          "Start Assesment",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Container nLPButton() {
    return Container(
      width: 200,
      child: OutlineButton(
        highlightColor: Colors.white24,
        color: Colors.blue,
        textColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          if (_filter.text != null && _filter.text.isNotEmpty)
            try {
              var nLP =
                  await APIController.getNLPModel(context, text: _filter.text);
              if (nLP != null) {
                postData(nLP);
              }
              setState(() {
                isLoading = false;
              });
            } catch (e) {
              setState(() {
                isLoading = false;
              });
              print(e.toString());
            }
        },
        child: Text(
          "Continue",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = new Icon(Icons.close);
        _appBarTitle = new TextField(
          controller: _filter,
          maxLines: null,
          onChanged: (val) {
            setState(() {
              nLPText = val;
            });
          },
          decoration: new InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: new Icon(Icons.edit),
              hintText: 'I am ...'),
        );
      } else {
        _searchIcon = new Icon(Icons.search);
        _appBarTitle = null;
      }
    });
  }

  datax() async {
    /*  var querySnapshot = await Firestore.instance
        .collection("users")
        .document(widget.user.uid)
        .get();
    print("ProfileModel data");
 var string = "foo",
    substring = "oo";
var d = string.indexOf(substring) != -1;
 
    if (querySnapshot != null) {
      //  print("User Data:" + querySnapshot.data.toString());
      setState(() {
        userModel = UserModel.fromSnapshot(querySnapshot);
      });
      eraseItem(key: 'userData');
      saveItem(key: 'userData', item: json.encode(querySnapshot.data));
    } else {
      // doc.data() will be undefined in this case
      print("No such document!");
    }

    if ((await getItemData(key: 'userData')) != null) {
      // querySnapshot = jsonDecode(prefs.getString('snap'));
      var data = jsonDecode((await getItemData(key: 'userData')));
      setState(() {
        userModel = UserModel.fromMap(data);
      });
    }*/
  }

  postData(NLPModel nLP) async {
    List<Evidence> evidence = new List();

    for (var i = 0; i < nLP.mentions.length; i++) {
      evidence.add(
          Evidence(choiceId: nLP.mentions[i].choiceId, id: nLP.mentions[i].id));
    }

    SubmitSymptoms data = new SubmitSymptoms(
        age: getAge(widget.userModel.birthDay),
        sex: widget.userModel.gender.toLowerCase(),
        evidence: evidence);
    // print(data.toJson());
    DiagnosisResponse temp =
        await APIController.getDiagnosis(context, data: data);

    if (temp != null)
      this.widget.changeView(Diagnosis(
            changeView: this.widget.changeView,
            diagnosisResponse: temp,
            userModel: widget.userModel,
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: _searchIcon.icon == Icons.search
              ? null
              : Text(
                  'How do you Feel?',
                  style: TextStyle(color: Colors.black),
                ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: _searchPressed,
              icon: Icon(
                _searchIcon.icon,
                color: Colors.blue,
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: _searchIcon.icon == Icons.search
            ? Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    cYM(40),
                    Image.asset('assets/images/mediac2.png'),
                    cYM(20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'Hi ${(widget.userModel.name).contains(' ') ? widget?.userModel?.name?.split(' ')[1] : widget?.userModel?.name ?? ''},\nHow can I help you?\nJust start a symptom assesment',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                    ),
                    cYM(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        startButton(),
                      ],
                    ),
                    cYM(30),
                    Text(
                      'Mediac',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  cYM(20),
                  _appBarTitle,
                  cYM(40),
                  nLPText != null
                      ? !isLoading
                          ? nLPButton()
                          : Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            )
                      : Container()
                ],
              ));
  }
}
