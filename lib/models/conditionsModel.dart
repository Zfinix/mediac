class ConditionsModel {
  List<Data> data;

  ConditionsModel({this.data});

  ConditionsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String name;
  String commonName;
  String sexFilter;
  List<String> categories;
  String prevalence;
  String acuteness;
  String severity;
  Extras extras;
  String triageLevel;

  Data(
      {this.id,
      this.name,
      this.commonName,
      this.sexFilter,
      this.categories,
      this.prevalence,
      this.acuteness,
      this.severity,
      this.extras,
      this.triageLevel});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    commonName = json['common_name'];
    sexFilter = json['sex_filter'];
    categories = json['categories'].cast<String>();
    prevalence = json['prevalence'];
    acuteness = json['acuteness'];
    severity = json['severity'];
    extras =
        json['extras'] != null ? new Extras.fromJson(json['extras']) : null;
    triageLevel = json['triage_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['common_name'] = this.commonName;
    data['sex_filter'] = this.sexFilter;
    data['categories'] = this.categories;
    data['prevalence'] = this.prevalence;
    data['acuteness'] = this.acuteness;
    data['severity'] = this.severity;
    if (this.extras != null) {
      data['extras'] = this.extras.toJson();
    }
    data['triage_level'] = this.triageLevel;
    return data;
  }
}

class Extras {
  String hint;
  String icd10Code;

  Extras({this.hint, this.icd10Code});

  Extras.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    icd10Code = json['icd10_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['icd10_code'] = this.icd10Code;
    return data;
  }
}