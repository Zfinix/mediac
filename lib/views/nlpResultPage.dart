import 'package:flutter/material.dart';
import 'package:mediac/models/NLPModel.dart';

class NLPResult extends StatefulWidget {
  final NLPModel nlpModel;
  const NLPResult({Key key, @required this.nlpModel}) : super(key: key);

  _NLPResultState createState() => _NLPResultState();
}

class _NLPResultState extends State<NLPResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: <Widget>[
        
      ],
    ));
  }
}
