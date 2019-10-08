import 'package:flutter/material.dart';
import 'package:mediac/utils/conectivity.dart';
import 'package:mediac/utils/margin_utils.dart';

class Dialog extends StatefulWidget {
  Dialog({Key key}) : super(key: key);

  _DialogState createState() => _DialogState();
}

class _DialogState extends BaseState<Dialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.85),
      body: Column(
        children: <Widget>[
          Text('Your Message Here'),
          cYM(30),
          IconButton(
            color: Colors.red,
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
