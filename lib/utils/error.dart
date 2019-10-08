import 'package:flutter/material.dart';


showError({@required context, @required String text}) => showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        elevation: 0,
        title: new Text("Error"),
        content: new Text("$text"),
      ),
    );
