import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mediac/functions/databaseFunc.dart';
import 'package:mediac/logic/demoData.dart';
import 'package:mediac/models/conditionsModel.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:mediac/models/submitSymptoms.dart';
import 'package:mediac/models/symptomsModel.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/views/detail/conditionDetail.dart';
import 'controller.dart';
import 'detail/sicknessDetail.dart';

class SymptomsOffline extends StatefulWidget {
  final Function changeView;
  final UserModel userModel;
  SymptomsOffline(
      {Key key, @required this.changeView, @required this.userModel})
      : super(key: key);

  _SymptomsOfflineState createState() => _SymptomsOfflineState();
}

class _SymptomsOfflineState extends State<SymptomsOffline> {
  String _search;
  List<Data> symptomsModel = List();
  List<Data> selectedSymptoms = List();
  List<Conditions> conditionsList = List();
  ConditionData anxietyData,
      bronchitisData,
      chlamydiaData,
      depressionData,
      diabetesData,
      diverticulitisData,
      endometriosisData,
      fibromyalgiaData,
      hemorrhoidData,
      herpesData,
      hpvData,
      lupusData,
      lymeData,
      pneumoniaData,
      psoriasisData,
      scabiesData,
      schizophreniaData,
      shinglesData,
      strepThroatData,
      yeastInfectionData;

  var isLoading = true,
      isEmpty = false,
      isSearching = false,
      isLoadingButton = false;

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
                              userModel: widget.userModel,
                              changeView: this.widget.changeView,
                            ));
                      })
                  : !isLoadingButton
                      ? submitButton()
                      : Column(
                          children: <Widget>[CircularProgressIndicator()],
                        ))
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
        itemCount: symptomsModel?.length ?? 0,
        itemBuilder: (BuildContext context, int i) {
          if (isSearching) {
            if (symptomsModel[i]
                .name
                .toLowerCase()
                .contains(_search.toLowerCase())) {
              return Column(
                children: <Widget>[
                  CheckboxListTile(
                    value: selectedSymptoms.contains(symptomsModel[i]),
                    onChanged: (bool selected) {
                      _onSymptomSelected(selected, symptomsModel[i]);
                    },
                    title: Text(
                      symptomsModel[i].name,
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
                  value: selectedSymptoms.contains(symptomsModel[i]),
                  onChanged: (bool selected) {
                    _onSymptomSelected(selected, symptomsModel[i]);
                  },
                  title: Text(
                    symptomsModel[i].name,
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
      for (var database in temp.data) {
        for (var disease in OfflineDisease.listOfDisease()) {
          if (database.id == disease) {
            setState(() {
              symptomsModel.add(database);
            });
          }
        }
        setState(() {
          isLoading = false;
        });
      }
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

    /*  SubmitSymptoms data = new SubmitSymptoms(
        age: getAge(widget.userModel.birthDay),
        sex: widget.userModel.gender.toLowerCase(),
        evidence: evidence);
    // print(data.toJson());
 */
    var evidenceList = [];

    for (var item in evidence) {
      evidenceList.add(item.id);
    }

    //Loading Demo Disease and Determinig which of them is most
    //similar to the symptoms selected by the user

    var anxiety = evidenceList
        .toSet()
        .intersection(OfflineDisease.anxiety.toSet())
        .length;

    var bronchitis = evidenceList
        .toSet()
        .intersection(OfflineDisease.bronchitis.toSet())
        .length;

    var chlamydia = evidenceList
        .toSet()
        .intersection(OfflineDisease.chlamydia.toSet())
        .length;

    var depression = evidenceList
        .toSet()
        .intersection(OfflineDisease.depression.toSet())
        .length;

    var diabetes = evidenceList
        .toSet()
        .intersection(OfflineDisease.diabetes.toSet())
        .length;

    var diverticulitis = evidenceList
        .toSet()
        .intersection(OfflineDisease.diverticulitis.toSet())
        .length;

    var endometriosis = evidenceList
        .toSet()
        .intersection(OfflineDisease.endometriosis.toSet())
        .length;

    var fibromyalgia = evidenceList
        .toSet()
        .intersection(OfflineDisease.fibromyalgia.toSet())
        .length;

    var hemorrhoid = evidenceList
        .toSet()
        .intersection(OfflineDisease.hemorrhoid.toSet())
        .length;

    var herpes =
        evidenceList.toSet().intersection(OfflineDisease.herpes.toSet()).length;

    var hpv =
        evidenceList.toSet().intersection(OfflineDisease.hpv.toSet()).length;

    var lupus =
        evidenceList.toSet().intersection(OfflineDisease.lupus.toSet()).length;

    var lyme =
        evidenceList.toSet().intersection(OfflineDisease.lyme.toSet()).length;

    var pneumonia = evidenceList
        .toSet()
        .intersection(OfflineDisease.pneumonia.toSet())
        .length;

    var psoriasis = evidenceList
        .toSet()
        .intersection(OfflineDisease.psoriasis.toSet())
        .length;

    var scabies = evidenceList
        .toSet()
        .intersection(OfflineDisease.scabies.toSet())
        .length;

    var schizophrenia = evidenceList
        .toSet()
        .intersection(OfflineDisease.schizophrenia.toSet())
        .length;

    var shingles = evidenceList
        .toSet()
        .intersection(OfflineDisease.shingles.toSet())
        .length;

    var strepThroat = evidenceList
        .toSet()
        .intersection(OfflineDisease.strepThroat.toSet())
        .length;

    var yeastInfection = evidenceList
        .toSet()
        .intersection(OfflineDisease.yeastInfection.toSet())
        .length;

    var listOfDiseaseFiltered = [
      anxiety,
      bronchitis,
      chlamydia,
      depression,
      diabetes,
      diverticulitis,
      endometriosis,
      fibromyalgia,
      hemorrhoid,
      herpes,
      hpv,
      lupus,
      lyme,
      pneumonia,
      psoriasis,
      scabies,
      schizophrenia,
      shingles,
      strepThroat,
      yeastInfection,
    ];

//Calculate probability of the disease
    var highestProbability = listOfDiseaseFiltered.reduce(max);

    var conditions = await DatabaseFunc.loadConditions();

    for (var item in conditions.data) {
      if (item.id == 'c_225') {
        anxietyData = item;
      }
      if (item.id == 'c_72') {
        bronchitisData = item;
      }
      if (item.id == 'c_1000000') {
        chlamydiaData = item;
      }
      if (item.id == 'c_26') {
        depressionData = item;
      }
      if (item.id == 'c_404') {
        diabetesData = item;
      }
      if (item.id == 'c_186') {
        diverticulitisData = item;
      }
      if (item.id == 'c_31') {
        endometriosisData = item;
      }
      if (item.id == 'c_598') {
        fibromyalgiaData = item;
      }
      if (item.id == 'c_147') {
        hemorrhoidData = item;
      }
      if (item.id == 'c_534') {
        herpesData = item;
      }
      if (item.id == 'c_2000000') {
        hpvData = item;
      }
      if (item.id == 'c_109') {
        lupusData = item;
      }
      if (item.id == 'c_182') {
        lymeData = item;
      }
      if (item.id == 'c_127') {
        pneumoniaData = item;
      }
      if (item.id == 'c_43') {
        psoriasisData = item;
      }
      if (item.id == 'c_589') {
        scabiesData = item;
      }
      if (item.id == 'c_310') {
        schizophreniaData = item;
      }
      if (item.id == 'c_78') {
        shinglesData = item;
      }
      if (item.id == 'c_249') {
        strepThroatData = item;
      }
      if (item.id == 'c_732') {
        yeastInfectionData = item;
      }
    }
    var total = listOfDiseaseFiltered.reduce((a, b) => a + b);

    for (var i = 0; i < listOfDiseaseFiltered.length; i++) {
      if (i == 0 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: anxietyData.id,
                  name: anxietyData.name,
                  condition: [anxietyData],
                  commonName: anxietyData.commonName,
                  probability: double.parse('$anxiety') / total),
              userModel: widget.userModel,
              probability: double.parse('$anxiety') / total,
            ));
        break;
      }
      if (i == 1 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: bronchitisData.id,
                  name: bronchitisData.name,
                  condition: [bronchitisData],
                  commonName: bronchitisData.commonName,
                  probability: double.parse('$bronchitis') / total),
              userModel: widget.userModel,
              probability: double.parse('$bronchitis') / total,
            ));
        break;
      }
      if (i == 2 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: chlamydiaData.id,
                  name: chlamydiaData.name,
                  condition: [chlamydiaData],
                  commonName: chlamydiaData.commonName,
                  probability: double.parse('$chlamydia') / total),
              userModel: widget.userModel,
              probability: double.parse('$chlamydia') / total,
            ));
        break;
      }
      if (i == 3 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: depressionData.id,
                  name: depressionData.name,
                  condition: [depressionData],
                  commonName: depressionData.commonName,
                  probability: double.parse('$depression') / total),
              userModel: widget.userModel,
              probability: double.parse('$depression') / total,
            ));
        break;
      }
      if (i == 4 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: diabetesData.id,
                  name: diabetesData.name,
                  condition: [diabetesData],
                  commonName: diabetesData.commonName,
                  probability: double.parse('$diabetes') / total),
              userModel: widget.userModel,
              probability: double.parse('$diabetes') / total,
            ));
        break;
      }
      if (i == 5 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: diverticulitisData.id,
                  name: diverticulitisData.name,
                  condition: [diverticulitisData],
                  commonName: diverticulitisData.commonName,
                  probability: double.parse('$diverticulitis') / total),
              userModel: widget.userModel,
              probability: double.parse('$diverticulitis') / total,
            ));
        break;
      }
      if (i == 6 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: endometriosisData.id,
                  name: endometriosisData.name,
                  condition: [endometriosisData],
                  commonName: endometriosisData.commonName,
                  probability: double.parse('$endometriosis') / total),
              userModel: widget.userModel,
              probability: double.parse('$endometriosis') / total,
            ));
        break;
      }
      if (i == 7 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: fibromyalgiaData.id,
                  name: fibromyalgiaData.name,
                  condition: [fibromyalgiaData],
                  commonName: fibromyalgiaData.commonName,
                  probability: double.parse('$fibromyalgia') / total),
              userModel: widget.userModel,
              probability: double.parse('$fibromyalgia') / total,
            ));
        break;
      }
      if (i == 8 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: hemorrhoidData.id,
                  name: hemorrhoidData.name,
                  condition: [hemorrhoidData],
                  commonName: hemorrhoidData.commonName,
                  probability: double.parse('$hemorrhoid') / total),
              userModel: widget.userModel,
              probability: double.parse('$hemorrhoid') / total,
            ));
        break;
      }
      if (i == 9 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: herpesData.id,
                  name: herpesData.name,
                  condition: [herpesData],
                  commonName: herpesData.commonName,
                  probability: double.parse('$herpes') / total),
              userModel: widget.userModel,
              probability: double.parse('$herpes') / total,
            ));
        break;
      }
      if (i == 10 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: hpvData.id,
                  name: hpvData.name,
                  condition: [hpvData],
                  commonName: hpvData.commonName,
                  probability: double.parse('$hpv') / total),
              userModel: widget.userModel,
              probability: double.parse('$hpv') / total,
            ));
        break;
      }
      if (i == 11 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: lupusData.id,
                  name: lupusData.name,
                  condition: [lupusData],
                  commonName: lupusData.commonName,
                  probability: double.parse('$lupus') / total),
              userModel: widget.userModel,
              probability: double.parse('$lupus') / total,
            ));
        break;
      }
      if (i == 12 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: lymeData.id,
                  name: lymeData.name,
                  condition: [lymeData],
                  commonName: lymeData.commonName,
                  probability: double.parse('$lyme') / total),
              userModel: widget.userModel,
              probability: double.parse('$lyme') / total,
            ));
        break;
      }
      if (i == 13 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: pneumoniaData.id,
                  name: pneumoniaData.name,
                  condition: [pneumoniaData],
                  commonName: pneumoniaData.commonName,
                  probability: double.parse('$pneumonia') / total),
              userModel: widget.userModel,
              probability: double.parse('$pneumonia') / total,
            ));
        break;
      }
      if (i == 14 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: psoriasisData.id,
                  name: psoriasisData.name,
                  condition: [psoriasisData],
                  commonName: psoriasisData.commonName,
                  probability: double.parse('$psoriasis') / total),
              userModel: widget.userModel,
              probability: double.parse('$psoriasis') / total,
            ));
        break;
      }
      if (i == 15 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: scabiesData.id,
                  name: scabiesData.name,
                  condition: [scabiesData],
                  commonName: scabiesData.commonName,
                  probability: double.parse('$scabies') / total),
              userModel: widget.userModel,
              probability: double.parse('$scabies') / total,
            ));

        break;
      }
      if (i == 16 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: schizophreniaData.id,
                  name: schizophreniaData.name,
                  condition: [schizophreniaData],
                  commonName: schizophreniaData.commonName,
                  probability: double.parse('$schizophrenia') / total),
              userModel: widget.userModel,
              probability: double.parse('$schizophrenia') / total,
            ));

        break;
      }
      if (i == 17 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: shinglesData.id,
                  name: shinglesData.name,
                  condition: [shinglesData],
                  commonName: shinglesData.commonName,
                  probability: double.parse('$shingles') / total),
              userModel: widget.userModel,
              probability: double.parse('$shingles') / total,
            ));

        break;
      }
      if (i == 18 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: strepThroatData.id,
                  name: strepThroatData.name,
                  condition: [strepThroatData],
                  commonName: strepThroatData.commonName,
                  probability: double.parse('$strepThroat') / total),
              userModel: widget.userModel,
              probability: double.parse('$strepThroat') / total,
            ));
        break;
      }
      if (i == 19 && listOfDiseaseFiltered[i] == highestProbability) {
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
              condition: Conditions(
                  id: yeastInfectionData.id,
                  name: yeastInfectionData.name,
                  condition: [yeastInfectionData],
                  commonName: yeastInfectionData.commonName,
                  probability: double.parse('$yeastInfection') / total),
              userModel: widget.userModel,
              probability: double.parse('$yeastInfection') / total,
            ));
        break;
      }
    }
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
