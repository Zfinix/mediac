import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediac/functions/databaseFunc.dart';
import 'package:mediac/models/conditionsModel.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/date.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/views/detail/conditionDetail.dart';

class SicknessDetail extends StatefulWidget {
  final Function changeView;
  final Conditions condition;
  const SicknessDetail(
      {Key key,
      @required this.changeView,
      this.condition})
      : super(key: key);

  _SicknessDetailState createState() => _SicknessDetailState();
}

class _SicknessDetailState extends State<SicknessDetail> {
  UserModel userModel;
  Data illness;
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              cYM(20),
              Image.asset('assets/images/mediac2.png'),
              cYM(20),
              Text(
                'Hey ${userModel.name.contains(' ') ? userModel.name.split(' ')[1] : userModel?.name ?? ''},'
                ' Your Results are in:\nFrom our Diagnosis and your response',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              cYM(50),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(11.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      new BoxShadow(
                        offset: Offset(0, 20),
                        spreadRadius: -13,
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Name: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14),
                            ),
                            Text(
                              '${userModel?.name}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      cYM(10),
                      Row(
                        children: <Widget>[
                          Text(
                            'Age: ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 14),
                          ),
                          Text(
                            '${getAge(userModel.birthDay)  ?? 0}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      cYM(10),
                      Container(
                        width: 400,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Pressing Issue: ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              '${widget?.condition?.commonName ?? ''}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      cYM(10),
                      Container(
                        width: 400,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Pobability: ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            cXM(5),
                            Text(
                              '${((widget?.condition?.probability ?? 0) * 100).toStringAsFixed(2)} %',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      cYM(10),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Summary: ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            cXM(10),
                            Container(
                              width: 210,
                              child: Text(
                                'Your may be suffering from ${widget?.condition?.commonName ?? ''} based on the symptops provided. '
                                '${illness?.extras?.hint}',
                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      cYM(10),
                      Divider(),
                      cYM(10),
                      Text(
                        '"This is not a comprehensive list. You might have a condition not suggested here. Please visit a medical practitioner if you are concerned about your health"',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
              cYM(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
        onPressed: () {
          this.widget.changeView(ConditionDetail(
                userModel: userModel,
                illness: illness,
                changeView: widget.changeView,
              ));
        },
        child: Text(
          "View Details",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<Data> loadData() async {
    var data = await DatabaseFunc.loadConditions();
    for (var item in data.data) {
      if (item.id == widget.condition.id) {
        return item;
      }
    }
    return null;
  }

  void init() async {
    var v = await loadData();
    if (v != null)
      setState(() {
        illness = v;
      });
  }
}
