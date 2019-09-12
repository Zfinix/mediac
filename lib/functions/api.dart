import 'dart:convert';

import 'package:mediac/models/NLPModel.dart';
import 'package:mediac/models/diagnosisResponse.dart';
import 'package:flutter/material.dart';
import 'package:mediac/models/submitSymptoms.dart';
import 'package:mediac/utils/url.dart';
import 'package:http/http.dart' as http;

class APIController {
  static Future<DiagnosisResponse> getDiagnosis(context,
      {@required SubmitSymptoms data}) async {
    try {
      var headers = {
        'App-Id': API.AppID,
        'App-Key': API.AppKey,
        'Content-type': 'application/json;charset=UTF-8',
      };

      var body = {};
      body["sex"] = data.sex;
      body["age"] = data.age;
      body["evidence"] = data.evidence;

      print(json.encode(body));

      //POST REQUEST BUILD
      final response = await http.post(API.Diagnosis,
          headers: headers, body: json.encode(body));

      print(response.body);

      if (response.statusCode == 200) {
        //  saveItem(item: '${response.body}', key: 'message');
        return DiagnosisResponse.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  static Future<NLPModel> getNLPModel(context, {@required String text}) async {
    try {
      var headers = {
        'App-Id': API.AppID,
        'App-Key': API.AppKey,
        'Content-type': 'application/json;charset=UTF-8',
      };
      var body = {"text": text};
      print(json.encode(body));

      //POST REQUEST BUILD
      final response =
          await http.post(API.NLP, headers: headers, body: json.encode(body));

      print(response.body);

      if (response.statusCode == 200) {
        return NLPModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {

      print(e.toString());
    }

    return null;
  }
}

class TwilioAPI {
  static Future<DiagnosisResponse> getDiagnosis(context,
      {@required SubmitSymptoms data}) async {
    try {
      var headers = {
        'App-Id': API.AppID,
        'App-Key': API.AppKey,
        'Content-type': 'application/json;charset=UTF-8',
      };

      var body = {};
      body["sex"] = data.sex;
      body["age"] = data.age;
      body["evidence"] = data.evidence;

      print(json.encode(body));

      //POST REQUEST BUILD

      final response = await http.post(API.Diagnosis,
          headers: headers, body: json.encode(body));

      print(response.body);

      if (response.statusCode == 200) {
        //  saveItem(item: '${response.body}', key: 'message');
        return DiagnosisResponse.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      //if (e.response.body != null) {

      print(e.toString());
    }

    return null;
  }
}
