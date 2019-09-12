class SubmitSymptoms {
  String sex;
  int age;
  List<Evidence> evidence;

  SubmitSymptoms({this.sex, this.age, this.evidence});

  SubmitSymptoms.fromJson(Map<String, dynamic> json) {
    sex = json['sex'];
    age = json['age'];
    if (json['evidence'] != null) {
      evidence = new List<Evidence>();
      json['evidence'].forEach((v) {
        evidence.add(new Evidence.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sex"] = this.sex;
    data["age"] = this.age;
    if (this.evidence != null) {
      data["evidence"] = this.evidence.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Evidence {
  String id;
  String choiceId;

  Evidence({this.id, this.choiceId});

  Evidence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    choiceId = json['choice_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['choice_id'] = this.choiceId;
    return data;
  }
}