import 'package:flutter/material.dart';
import 'package:mediac/models/NLPModel.dart';
import 'package:mediac/utils/conectivity.dart';

class NLPResult extends StatefulWidget {
  final NLPModel nlpModel;
  const NLPResult({Key key, @required this.nlpModel}) : super(key: key);

  _NLPResultState createState() => _NLPResultState();
}

class _NLPResultState extends BaseState<NLPResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      children: <Widget>[
        
      ],
    ));
  }
}
