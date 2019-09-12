import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediac/auth/login.dart';
import 'package:mediac/auth/signup/birthday.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/utils/persistence.dart';
import 'package:mediac/utils/validator.dart';
import 'baseAuth.dart';

class Signup extends StatefulWidget {
  const Signup(
    this.changeView, {
    Key key,
  }) : super(key: key);

  final Function changeView;

  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final BaseAuth auth = new Auth();
  final _formKey = GlobalKey<FormState>();
  String email, password, name, cmPassword, address, gender = 'Male';

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset('assets/images/mediac2.png'),
                cYM(20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'Welcome to Mediac.\nPlease create an account.',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 19),
                  ),
                ),
                cYM(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        _buildName(),
                        cYM(10),
                        _buildEmail(),
                        cYM(10),
                        _buildAddress(),
                        cYM(10),
                        _buildPassword(),
                        cYM(10),
                        _buildCmPassword(),
                        cYM(19),
                        !isLoading
                            ? signInButton()
                            : Container(
                                height: 26,
                                width: 26,
                                child: CircularProgressIndicator(),
                              ),
                        cYM(10),
                        !isLoading
                            ? Container(
                                height: 20,
                                child: FlatButton(
                                  highlightColor: Colors.white24,
                                  textColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    this.widget.changeView(
                                        Login(this.widget.changeView));
                                  },
                                  child: Text("Have an Account ? Sign in"),
                                ),
                              )
                            : Container(),
                      ],
                    ),
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
          ],
        ),
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
        onPressed: () => postData(),
        child: Text(
          "Create Account",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  _buildName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        // initialValue: 'chiziaruhoma@gmail.com',
        validator: (value) {
          if (value.isNotEmpty) {
            setState(() {
              name = value;
            });
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Name is Invalid";
          }
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
            ),
            hintText: 'Name'),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  _buildEmail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        initialValue: 'chiziaruhoma@gmail.com',
        validator: (value) {
          if (isEmail(value)) {
            setState(() {
              email = value;
            });
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Email is Invalid";
          }
        },
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
            ),
            hintText: 'Email'),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  _buildPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        initialValue: 'qqqqqq',
        validator: (value) {
          if (value.length > 4) {
            setState(() {
              password = value;
            });
            return null;
          } else if (value.isEmpty) {
            return "This field can't be left empty";
          } else {
            return "Password is Invalid";
          }
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          hintText: 'Password',
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
      ),
    );
  }

  _buildCmPassword() => Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextFormField(
          initialValue: 'qqqqqq',
          validator: (value) {
            if (value == password) {
              setState(() {
                password = value;
              });
              return null;
            } else if (value.isEmpty) {
              return "This field can't be left empty";
            } else {
              return "Password don't match";
            }
          },
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              hintText: 'Confirm Password'),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
      );

  _buildAddress() => Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextFormField(
            // initialValue: 'chiziaruhoma@gmail.com',
            validator: (value) {
              if (value != null) {
                setState(() {
                  address = value;
                });
                return null;
              } else {
                setState(() {
                  address = 'Not Available';
                });
                return 'Invalid Address';
              }
            },
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(80),
                ),
                hintText: 'Address'),
            keyboardType: TextInputType.text),
      );

  postData() async {
    String userId = "";
    if (_formKey.currentState.validate() &&
        // selectedDate.year != null &&
        !gender.contains("en")) {
      setState(() {
        isLoading = true;
      });
      try {
        //userId = await auth.signUp(email, password);

        saveData(name, email, password, address, userId);

        print('Signed in: $userId');

        if (userId.length > 0 && userId != null) {}
      } catch (e) {
        print('Error: $e');

        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Error"),
                  content: new Text("$e"),
                ));
      }
    }
  }

  saveData(String name, String email, String password, String address,
      userId) async {
    try {
      //DEACTIVATING FIREBASE
      /*  FirebaseUser user = await auth.getCurrentUser();
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = name;
      user.updateProfile(updateInfo);

      Firestore.instance.runTransaction((transaction) async {
        await transaction
            .set(Firestore.instance.collection("users").document(userId), {
          'name': name,
          'email': email,
          'address': address,
          'userId': userId,
          'imageUrl': ""
        });
      });
 */
      var user = UserModel(
        name: '$name',
        email: '$email',
        address: '$address',
        gender: '$gender',
      );

      await saveItem(key: 'user', item: json.encode(user.toJson()));
      await saveItem(key: 'pass', item: password);

      setState(() {
        isLoading = false;
      });
      this.widget.changeView(Birthday(
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
