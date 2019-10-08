import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mediac/auth/signup.dart';
import 'package:mediac/models/offlineUserModel.dart';
import 'package:mediac/utils/base64/images.dart';
import 'package:mediac/utils/margin_utils.dart';
import 'package:mediac/utils/persistence.dart';
import 'package:mediac/utils/validator.dart';
import 'package:mediac/views/controller.dart';

import 'baseAuth.dart';

class Login extends StatefulWidget {
  const Login(
    this.changeView, {
    Key key,
  }) : super(key: key);

  final Function changeView;

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final BaseAuth auth = new Auth();
  final _formKey = GlobalKey<FormState>();
  String email;
  String password, pass;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/mediac2.png'),
            cYM(20),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                'Welcome Back.\nPlease sign in.',
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
                    _buildEmail(),
                    cYM(10),
                    _buildPassword(),
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
                                this
                                    .widget
                                    .changeView(Signup(this.widget.changeView));
                              },
                              child: Text("Create an Account"),
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
      ),
    );
  }

  Container signInButton() {
    return Container(
      width: 100,
      color: Colors.white,
      child: OutlineButton(
        highlightColor: Colors.white24,
        color: Colors.blue,
        textColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () => postData(),
        child: Text(
          "Sign in",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  _buildEmail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        // initialValue: 'chiziaruhoma@gmail.com',
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
        // initialValue: 'qqqqqq',
        validator: (value) {
          if (value.isNotEmpty && value.length > 4) {
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

  postData() async {
    if (_formKey.currentState.validate() &&
        (await getItemData(key: 'user')) != null) {
      setState(() {
        isLoading = true;
      });
      try {
        UserModel user =
            UserModel.fromJson(json.decode(await getItemData(key: 'user')));

        print('Signed in: ${user.name}');

        if (user != null) {
          print(user.toJson());
          this.widget.changeView(Controller(
                userModel: user,
                changeView: this.widget.changeView,
              ));
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
        });
        if (e.toString().contains("invalid")) {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                  elevation: 0,
                    title: new Text("Error"),
                    content: new Text("This password is invalid"),
                  ));
        } else {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                  elevation: 0,
                    title: new Text("Error"),
                    content: new Text("$e"),
                  ));
        }
      }
    } else {
      if ((await getItemData(key: 'user')) == null)
        showDialog(
            context: context,
            builder: (_) => Container(
                 
                  child: new AlertDialog(
                    elevation: 0,
                    title: new Text("Error"),
                    content: new Text("Please Create An Account First"),
                  ),
                ));
    }
  }

  void loadData() async {
    pass = await getItemData(key: 'pass');
  }
}
