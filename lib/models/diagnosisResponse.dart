import 'package:mediac/models/conditionsModel.dart';

class DiagnosisResponse {
  Questions question;
  List<Conditions> conditions;
  // Extras extras;

  DiagnosisResponse({this.question, this.conditions});

  DiagnosisResponse.fromJson(Map<String, dynamic> json) {
    question = json['question'] != null
        ? new Questions.fromJson(json['question'])
        : null;
    if (json['conditions'] != null) {
      conditions = new List<Conditions>();
      json['conditions'].forEach((v) {
        conditions.add(new Conditions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.question != null) {
      data['question'] = this.question.toJson();
    }
    if (this.conditions != null) {
      data['conditions'] = this.conditions.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Conditions {
  String id;
  String name;
  String commonName;
  List <ConditionData> condition;
  double probability;

  Conditions({this.id, this.name, this.commonName, this.probability, this.condition});

  Conditions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    commonName = json['common_name'];
    probability = json['probability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['common_name'] = this.commonName;
    data['probability'] = this.probability;
    return data;
  }
}

class Questions {
  String type;
  String text;
  List<Items> items;

  Questions({this.type, this.text, this.items});

  Questions.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    text = json['text'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['text'] = this.text;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String id;
  String name;
  List<Choices> choices;

  Items({this.id, this.name, this.choices});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['choices'] != null) {
      choices = new List<Choices>();
      json['choices'].forEach((v) {
        choices.add(new Choices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.choices != null) {
      data['choices'] = this.choices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Choices {
  String id;
  String label;

  Choices({this.id, this.label});

  Choices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}
