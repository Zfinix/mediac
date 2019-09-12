import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediac/functions/databaseFunc.dart';
import 'package:mediac/models/conditionsModel.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/margin_utils.dart';

import '../controller.dart';

class ConditionDetail extends StatefulWidget {
  final Function changeView;
  final FirebaseUser user;
  final UserModel userModel;
  final Data illness;
  const ConditionDetail(
      {Key key,
      @required this.changeView,
      this.user,
      this.userModel,
      this.illness})
      : super(key: key);

  _ConditionDetailState createState() => _ConditionDetailState();
}

class _ConditionDetailState extends State<ConditionDetail> {
  UserModel userModel;

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
                '${widget.illness.name}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              cYM(5),
              Text(
                'Other Name : ${widget.illness.commonName}',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                ),
              ),
              cYM(5),
              Row(
                children: <Widget>[
                  Text(
                    'Categories:  ${widget.illness.categories}',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              cYM(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Chip(
                    backgroundColor: Colors.blue,
                    label: Text(
                      '${widget.illness.prevalence.replaceAll('_', ' ')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.blue,
                    label: Text(
                      '${widget.illness.acuteness.replaceAll('_', ' ')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.blue,
                    label: Text(
                      '${widget.illness.severity.replaceAll('_', ' ')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              cYM(35),
              Text(
                '${widget.illness.extras.hint}',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                ),
              ),

              cYM(15),
              Text(
                'Triage Level: ${widget.illness.triageLevel.replaceAll("_", " ").toUpperCase()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              cYM(65),
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
          this.widget.changeView(Controller(
                changeView: this.widget.changeView,
              ));
        },
        child: Text(
          "Go Home",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
