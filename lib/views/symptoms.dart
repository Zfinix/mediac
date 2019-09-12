import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediac/functions/databaseFunc.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:mediac/models/submitSymptoms.dart';
import 'package:mediac/models/symptomsModel.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/date.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/views/diagnosis.dart';
import 'package:mediac/functions/api.dart';

import 'controller.dart';

class Symptoms extends StatefulWidget {
  final Function changeView;
  final UserModel userModel;
  Symptoms(
      {Key key,
      @required this.changeView,
      @required this.userModel})
      : super(key: key);

  _SymptomsState createState() => _SymptomsState();
}

class _SymptomsState extends State<Symptoms> {
  String _search;
  SymptomsModel symptomsModel;
  List<Data> selectedSymptoms = List();

  var isLoading = true, isEmpty = false, isSearching = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void _onSymptomSelected(bool selected, Data category) {
    if (selected == true) {
      setState(() {
        selectedSymptoms.add(category);
      });
    } else {
      setState(() {
        selectedSymptoms.remove(category);
      });
    }
  }

  Container submitButton() {
    return Container(
      width: 200,
      child: MaterialButton(
        highlightColor: Colors.white24,
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => postData(),
        child: Text(
          "Continue",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                cYM(10),
                Text(
                  'Please select some symptoms',
                  style: TextStyle(fontSize: 18),
                ),
                _buildSearch(),
                cYM(10),
                !isLoading
                    ? !isEmpty ? _buildList() : Text('Couldnt Load Data')
                    : CircularProgressIndicator(),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: selectedSymptoms.length < 1
                  ? FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: Colors.blue),
                      onPressed: () {
                        this.widget.changeView(Controller(
                           //   user: this.widget.user,
                              changeView: this.widget.changeView,
                            ));
                      })
                  : submitButton())
        ],
      ),
    );
  }

  _buildSearch() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Center(
        child: TextField(
          // initialValue: 'chiziaruhoma@gmail.com',
          onChanged: (value) {
            if (value != null || value.isNotEmpty) {
              setState(() {
                isSearching = true;
                _search = value;
              });
            } else {
              setState(() {
                isSearching = false;
                _search = null;
              });
            }
          },
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              border: new UnderlineInputBorder(),
              suffixIcon: isSearching
                  ? IconButton(
                      icon: Icon(Icons.close, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          isSearching = false;
                        });
                      },
                    )
                  : null,
              hintText: 'Search...'),
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }

  _buildList() {
    return Flexible(
      child: ListView.builder(
        itemCount: symptomsModel?.data?.length ?? 0,
        itemBuilder: (BuildContext context, int i) {
          if (isSearching) {
            if (symptomsModel.data[i].name
                .toLowerCase()
                .contains(_search.toLowerCase())) {
              return Column(
                children: <Widget>[
                  CheckboxListTile(
                    value: selectedSymptoms.contains(symptomsModel.data[i]),
                    onChanged: (bool selected) {
                      _onSymptomSelected(selected, symptomsModel.data[i]);
                    },
                    title: Text(
                      symptomsModel.data[i].name,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Divider()
                ],
              );
            } else {
              return Container();
            }
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CheckboxListTile(
                  value: selectedSymptoms.contains(symptomsModel.data[i]),
                  onChanged: (bool selected) {
                    _onSymptomSelected(selected, symptomsModel.data[i]);
                  },
                  title: Text(
                    symptomsModel.data[i].name,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Divider()
              ],
            );
          }
        },
      ),
    );
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    var temp = await DatabaseFunc.loadSymptoms();
    if (temp != null) {
      setState(() {
        isLoading = false;
        symptomsModel = temp;
      });
    } else {
      print('null');
      setState(() {
        isEmpty = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  postData() async {
    List<Evidence> evidence = new List();

    for (var i = 0; i < selectedSymptoms.length; i++) {
      evidence.add(Evidence(choiceId: 'present', id: selectedSymptoms[i].id));
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
}

/* var dataM = {
  "question": {
    "type": "group_single",
    "text": "How strong is your headache?",
    "items": [
      {
        "id": "s_1780",
        "name": "Mild",
        "choices": [
          {"id": "present", "label": "Yes"},
          {"id": "absent", "label": "No"},
          {"id": "unknown", "label": "Don't know"}
        ]
      },
      {
        "id": "s_1781",
        "name": "Moderate",
        "choices": [
          {"id": "present", "label": "Yes"},
          {"id": "absent", "label": "No"},
          {"id": "unknown", "label": "Don't know"}
        ]
      },
      {
        "id": "s_1193",
        "name": "Severe",
        "choices": [
          {"id": "present", "label": "Yes"},
          {"id": "absent", "label": "No"},
          {"id": "unknown", "label": "Don't know"}
        ]
      }
    ],
    "extras": {}
  },
  "conditions": [
    {
      "id": "c_87",
      "name": "Common cold",
      "common_name": "Common cold",
      "probability": 0.1416
    },
    {
      "id": "c_10",
      "name": "Gastroenteritis",
      "common_name": "Gastroenteritis",
      "probability": 0.049
    },
    {
      "id": "c_138",
      "name": "Food poisoning",
      "common_name": "Food poisoning",
      "probability": 0.0468
    },
    {
      "id": "c_132",
      "name": "Appendicitis",
      "common_name": "Appendicitis",
      "probability": 0.0237
    },
    {
      "id": "c_215",
      "name": "Cholecystitis",
      "common_name": "Inflammation of the gallbladder",
      "probability": 0.0228
    },
    {
      "id": "c_676",
      "name": "Scarlet fever",
      "common_name": "Scarlet fever",
      "probability": 0.0227
    },
    {
      "id": "c_55",
      "name": "Tension-type headaches",
      "common_name": "Tension-type headaches",
      "probability": 0.0217
    },
    {
      "id": "c_133",
      "name": "Acute rhinosinusitis",
      "common_name": "Acute rhinosinusitis",
      "probability": 0.0204
    },
    {
      "id": "c_192",
      "name": "Mumps",
      "common_name": "Inflammation of parotid salivary glands",
      "probability": 0.0199
    }
  ],
  "extras": {}
};

var dataB = {
  "question": {
    "type": "group_single",
    "text": "How long have you had your headache?",
    "items": [
      {
        "id": "s_1912",
        "name": "Less than 3 months",
        "choices": [
          {"id": "present", "label": "Yes"},
          {"id": "absent", "label": "No"},
          {"id": "unknown", "label": "Don't know"}
        ]
      },
      {
        "id": "s_1535",
        "name": "More than 3 months",
        "choices": [
          {"id": "present", "label": "Yes"},
          {"id": "absent", "label": "No"},
          {"id": "unknown", "label": "Don't know"}
        ]
      }
    ],
    "extras": {}
  },
  "conditions": [
    {
      "id": "c_87",
      "name": "Common cold",
      "common_name": "Common cold",
      "probability": 0.3718
    },
    {
      "id": "c_55",
      "name": "Tension-type headaches",
      "common_name": "Tension-type headaches",
      "probability": 0.9199
    },
    {
      "id": "c_121",
      "name": "Acute viral tonsillopharyngitis",
      "common_name": "Acute viral tonsillopharyngitis",
      "probability": 0.0151
    },
    {
      "id": "c_133",
      "name": "Acute rhinosinusitis",
      "common_name": "Acute rhinosinusitis",
      "probability": 0.0145
    }
  ],
  "extras": {}
};
 */