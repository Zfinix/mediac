import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:mediac/models/conditionsModel.dart';
import 'package:mediac/models/symptomsModel.dart';

class DatabaseFunc {
  static Future<SymptomsModel> loadSymptoms() async {
    try {
      return SymptomsModel.fromJson(json
          .decode('${(await rootBundle.loadString('assets/database/symptoms.json'))}'));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  static Future<ConditionsModel> loadConditions() async {
    try {
      return ConditionsModel.fromJson(json
          .decode('${(await rootBundle.loadString('assets/database/conditions.json'))}'));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
