import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/utils/persistence.dart';
import 'package:mediac/views/controller.dart';

import '../baseAuth.dart';

class Gender extends StatefulWidget {
  const Gender(
    this.changeView, {
    Key key,
  }) : super(key: key);

  final Function changeView;
  // final FirebaseUser user;
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  final BaseAuth auth = new Auth();
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
              'Please Select your Gender',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 23),
            ),
          ),
          cYM(20),
          buttonChildren(),
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

  buttonChildren() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          cYM(10),
          !isLoading
              ? Container(
                  width: 150,
                  child: OutlineButton(
                    highlightColor: Colors.white24,
                    color: Colors.blue,
                    textColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () => saveData('Male'),
                    child: Text(
                      'Male',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : Container(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(),
                ),
          cYM(20),
          !isLoading
              ? Container(
                  width: 150,
                  child: OutlineButton(
                    highlightColor: Colors.white24,
                    color: Colors.blue,
                    textColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () => saveData('Female'),
                    child: Text(
                      "Female",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : Container(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(),
                ),
        ]);
  }

  saveData(String gender) async {
    try {
      /* Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
            Firestore.instance.collection("users").document(widget.user.uid), {
          'gender': gender,
        });
      }); */
      UserModel user = UserModel.fromJson(json.decode(await getItemData(key: 'user')));

      setState(() {
        user.gender = gender;
        isLoading = false;
      });
      await saveItem(key: 'user', item: json.encode(user.toJson()));

      // FirebaseUser user = await auth.getCurrentUser();
      this.widget.changeView(Controller(
              userModel: user,
            changeView: this.widget.changeView,
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
