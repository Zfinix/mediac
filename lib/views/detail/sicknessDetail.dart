import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediac/functions/databaseFunc.dart';
import 'package:mediac/models/conditionsModel.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/base64/images.dart';
import 'package:mediac/utils/date.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/views/controller.dart';
import 'package:mediac/views/detail/conditionDetail.dart';

class SicknessDetail extends StatefulWidget {
  final Function changeView;
  final List<Conditions> conditions;
  final Conditions condition;
  final bool isInconclusive;
  final UserModel userModel;
  final probability;
  const SicknessDetail(
      {Key key,
      this.isInconclusive = false,
      this.userModel,
      @required this.changeView,
      this.condition,
      this.probability,
      this.conditions})
      : super(key: key);

  _SicknessDetailState createState() => _SicknessDetailState();
}

class _SicknessDetailState extends State<SicknessDetail> {
  ConditionData illness;
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
            child: widget.condition != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      cYM(20),
                      Image.asset('assets/images/mediac2.png'),
                      cYM(20),
                      Text(
                        'Hey ${widget.userModel.name.contains(' ') ? widget.userModel.name.split(' ')[1] : widget.userModel?.name ?? ''},'
                        ' Your Results are in:\nFrom our Diagnosis and your response',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      cYM(50),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(base64.decode('$base64Image')),
                                ),
                                borderRadius: BorderRadius.circular(12),
                                 boxShadow: [
                                    new BoxShadow(
                                      offset: Offset(0, 20),
                                      spreadRadius: -13,
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 28,
                                    ),
                                  ],
                              ),
                            ),
                             Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.89),
                                  borderRadius: BorderRadius.circular(12),
                                 
                                )),
                           
                            Container(

                                padding: const EdgeInsets.all(16.0),
                              child: ListView(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Name: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              '${widget.userModel?.name}',
                                              style: TextStyle(
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
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            '${getAge(widget.userModel.birthDay) ?? 0}',
                                            style: TextStyle(
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
                                              style: TextStyle(
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              '${widget?.condition?.commonName ?? ''}',
                                              style: TextStyle(
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
                                              'Probability: ',
                                              style: TextStyle(
                                                  fontSize: 14),
                                            ),
                                            cXM(5),
                                            Text(
                                              '${((widget?.condition?.probability ?? 0) * 100).toStringAsFixed(2)} %',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      cYM(10),
                                      Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Summary: ',
                                              style: TextStyle(
                                                  fontSize: 14),
                                            ),
                                            cXM(10),
                                            Container(
                                              width: 210,
                                              child: Text(
                                                'Your may be suffering from ${widget?.condition?.commonName ?? ''} based on the symptops provided. '
                                                '${illness?.extras?.hint}',
                                                //overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      cYM(10),
                                      Divider(
                                        height: 6,
                                        thickness: 1,
                                      ),
                                      cYM(30),
                                      Text(
                                        '"This is not a comprehensive list. You might have a condition not suggested here. Please visit a medical practitioner if you are concerned about your health"',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      cYM(20),
                      Image.asset('assets/images/mediac2.png'),
                      cYM(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Hey ${widget.userModel.name.contains(' ') ? widget.userModel.name.split(' ')[1] : widget.userModel?.name ?? ''},',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          cYM(10),
                          widget.isInconclusive
                              ? Text(
                                  'Your Results are in but were inconclusive, We did not have Enough data to work with from your Replies',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                )
                              : Text(
                                  'Your Results are in but were inconclusive:\nFrom our Diagnosis and your response, here are a list of possible illnesses',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                        ],
                      ),
                      widget.conditions != null
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: widget?.conditions?.length ?? 0,
                                itemBuilder: (BuildContext context, int i) {
                                  return Column(
                                    children: <Widget>[
                                      Text(widget.conditions[i].name)
                                    ],
                                  );
                                },
                              ),
                            )
                          : Container(),
                      Divider(),
                      cYM(10),
                      Text(
                        '"This is not a comprehensive list. You might have a condition not suggested here. Please visit a medical practitioner if you are concerned about your health"',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            fontWeight: FontWeight.w300,
                            fontSize: 14),
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
                  )));
  }

  Container startButton() {
    return Container(
      width: 200,
      color: Colors.white,
      child: OutlineButton(
        highlightColor: Colors.white24,
        color: Colors.blue,
        textColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          if (widget.conditions == null && widget.condition != null) {
            this.widget.changeView(ConditionDetail(
                  userModel: widget.userModel,
                  illness: illness,
                  changeView: widget.changeView,
                  probability: widget.probability,
                ));
          } else {
            this.widget.changeView(Controller(
                  userModel: widget.userModel,
                  changeView: widget.changeView,
                ));
          }
        },
        child: Text(
          "View Details",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<ConditionData> loadData() async {
    var data = await DatabaseFunc.loadConditions();
    if (data.data != null)
      for (var item in data?.data) {
        if (item?.id == widget?.condition?.id) {
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
