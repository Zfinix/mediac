import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:mediac/models/submitSymptoms.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/date.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/views/symptoms.dart';
import 'detail/sicknessDetail.dart';
import 'package:mediac/functions/api.dart';

var isSelected = false;
var category = '';

class Diagnosis extends StatefulWidget {
  final Function changeView;
  final UserModel userModel;
  final DiagnosisResponse diagnosisResponse;
  final List<Conditions> otherConditions;

  Diagnosis(
      {Key key,
      @required this.changeView,
      @required this.userModel,
      @required this.diagnosisResponse,
      this.otherConditions})
      : super(key: key);

  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  List<Evidence> evidence = new List();
  double opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  height: 80, child: Image.asset('assets/images/mediac2.png')),
              Text(
                widget?.diagnosisResponse?.question?.text ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: _buildSliders()),
                  ],
                ),
              ),
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
        ));
  }

  Container startButton() {
    return Container(
      width: 200,
      child: OutlineButton(
        highlightColor: Colors.white24,
        color: Colors.blue,
        textColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => postData(),
        child: Text(
          widget?.diagnosisResponse?.question?.items != null &&
                  widget.diagnosisResponse.question.items.length > 1
              ? "Next Question"
              : "Submit Assesment",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSliders() {
    //double screenWidth = MediaQuery.of(context).size.width;

    return Swiper(
      loop: false,
      itemCount: widget?.diagnosisResponse?.question?.items?.length ?? 0,
      onIndexChanged: (i) {
        category = '';
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Divider(),
            cYM(5),
            Text(
              widget?.diagnosisResponse?.question?.items[i].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            cYM(20),
            _loadQuestions(widget?.diagnosisResponse?.question?.items[i])
          ],
        );
      },
      // control: new SwiperControl(),
      pagination: new SwiperPagination(
          builder: FractionPaginationBuilder(
              /*   size: 5,
              activeSize: 10, */
              color: Colors.blueAccent.withOpacity(0.5),
              activeColor: Colors.blueAccent)),
      viewportFraction: 1,
      scale: 0.9,
    );
  }

  _loadQuestions(Items item) {
    List<Widget> children = [];

    List<RadioModel> sampleData = new List<RadioModel>();
    item.choices.forEach((f) {
      sampleData.add(new RadioModel(f.label, '', () {
        print(item.id);
      }, category: new Evidence(choiceId: f.id, id: item.id)));
    });

    for (var button in sampleData) {
      children.add(GestureDetector(
        onTap: () {
          setState(() {
            print(isSelected);
            setState(() {
              category = button.category.choiceId;
            });

            onAnswerSelected(true, button.category);
          });
        },
        child: button.category.choiceId != category
            ? RadioItem(button, false)
            : RadioItem(button, true),
      ));
    }

    //  sampleData.removeRange(3, sampleData.length);

    return AnimatedOpacity(
      child: Container(
        child: Column(
          children: children,
        ),
      ),
      duration: new Duration(milliseconds: 700),
      opacity: opacity,
    );
  }

  onAnswerSelected(bool selected, Evidence category) {
    if (selected == true) {
      for (var i = 0; i < evidence.length; i++) {
        if (evidence[i].choiceId == category.choiceId) {
          print(evidence[i].choiceId);
          setState(() {
            evidence.removeLast();
          });
        }
      }

      setState(() {
        evidence.add(category);
      });
    } else {
      for (var item in evidence) {
        if (item.choiceId == category.choiceId)
          setState(() {
            evidence.removeLast();
          });
      }
    }
  }

  void animateView() async {
    setState(() {
      opacity = 0;
    });
    await Future.delayed(new Duration(seconds: 1));

    setState(() {
      opacity = 1.0;
    });
  }

  postData() async {
    animateView();
    SubmitSymptoms data = new SubmitSymptoms(
        age: getAge(widget?.userModel?.birthDay) ?? 10,
        sex: widget.userModel.gender.toLowerCase(),
        evidence: evidence);

    if (widget?.diagnosisResponse?.question?.items != null &&
        widget.diagnosisResponse.question.items.length > 1) {
      setState(() {
        widget?.diagnosisResponse?.question?.items?.removeAt(0);
      });
    } else {
      print('Yayyyy completeed Questions');
      print(data.toJson());
      DiagnosisResponse temp =
          await APIController.getDiagnosis(context, data: data);

      checkProbability(temp);
    }
  }

  void checkProbability(DiagnosisResponse diagnosisResponse) {
    double probability = 0;
    int currentSickness = 0;
    for (var i = 0; i < diagnosisResponse.conditions.length; i++) {
      if (diagnosisResponse.conditions[i].probability >= probability) {
        setState(() {
          currentSickness = i;
          probability = diagnosisResponse.conditions[i].probability;
        });
      }
    }
    print(probability);

    if (probability > 0.5 && currentSickness != null) {
      print(currentSickness);
      this.widget.changeView(SicknessDetail(
            changeView: this.widget.changeView,
            condition: diagnosisResponse.conditions[currentSickness],
          ));
    } else {
      if (diagnosisResponse != null)
        this.widget.changeView(SicknessDetail(
              changeView: this.widget.changeView,
            ));
    }
  }
}

class RadioItem extends StatefulWidget {
  final RadioModel item;
  final bool isSelected;
  RadioItem(this.item, this.isSelected);

  @override
  _RadioItemState createState() => _RadioItemState();
}

class _RadioItemState extends State<RadioItem> {
  @override
  Widget build(BuildContext context) {
    // print(widget.isSelected);
    return new Container(
      margin: new EdgeInsets.all(8.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 200.0,
            child: new Center(
              child: new Text(widget.item.buttonText,
                  style: new TextStyle(
                      color:
                          widget.isSelected ? Colors.white : Colors.grey[800],
                      //fontWeight: FontWeight.bold,
                      fontSize: 16.0)),
            ),
            decoration: new BoxDecoration(
              color: widget.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: widget.isSelected
                      ? Colors.blueAccent
                      : Colors.grey.withOpacity(0.3)),
              borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
            ),
          ),
          Center(
            child: new Text(widget.item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  final String buttonText;
  final String text;
  final VoidCallback onTap;
  final Evidence category;

  RadioModel(this.buttonText, this.text, this.onTap, {@required this.category});
}
