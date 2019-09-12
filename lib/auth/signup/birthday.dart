import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/date.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/utils/persistence.dart';
import 'package:mediac/views/controller.dart';

import '../baseAuth.dart';
import 'gender.dart';

class Birthday extends StatefulWidget {
  const Birthday(
    this.changeView, {
    Key key,
  }) : super(key: key);

  final Function changeView;
  //final FirebaseUser user;

  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  final BaseAuth auth = new Auth();
  String dob;

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'What is your date.\nof birth?',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 23),
            ),
          ),
          cYM(20),
          _buildDate(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  cYM(19),
                  !isLoading
                      ? signInButton()
                      : Container(
                          height: 26,
                          width: 26,
                          child: CircularProgressIndicator(),
                        ),
                  cYM(10),
                ],
              ),
            ],
          ),
          cYM(30),
          Text(
            'Mediac',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }

  Container signInButton() {
    return Container(
      //r   width: 150,
      child: OutlineButton(
        highlightColor: Colors.white24,
        color: Colors.blue,
        textColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => saveData(),
        child: Text(
          "Select your birthday",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  _buildDate() => Flexible(
        flex: 2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.9,
          child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  dob = value.toIso8601String();
                });
              },
              initialDateTime: DateTime.now(),
              maximumDate: null),
        ),
      );

  saveData() async {
    try {
      /* Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
            Firestore.instance.collection("users").document(widget.user.uid),
            {'birthDay': dob, 'age': getAge(dob)});
      }); */
      UserModel user =
          UserModel.fromJson(json.decode(await getItemData(key: 'user')));

      setState(() {
        user.birthDay = dob;
        isLoading = false;
      });
      await saveItem(key: 'user', item: json.encode(user.toJson()));
      setState(() {
        isLoading = false;
      });

      //FirebaseUser user = await auth.getCurrentUser();

      this.widget.changeView(Gender(
            this.widget.changeView,
          ));
    } catch (e) {
      setState(() {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text("${e.message}"),
                ));
      });

      ///showError(context: context, text:e.message);
      print('Error: ${e.message}');

      setState(() {
        isLoading = false;
      });
    }
  }
}
