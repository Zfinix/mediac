class NLPModel {
  List<Mentions> mentions;
  bool obvious;

  NLPModel({this.mentions, this.obvious});

  NLPModel.fromJson(Map<String, dynamic> json) {
    if (json['mentions'] != null) {
      mentions = new List<Mentions>();
      json['mentions'].forEach((v) {
        mentions.add(new Mentions.fromJson(v));
      });
    }
    obvious = json['obvious'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mentions != null) {
      data['mentions'] = this.mentions.map((v) => v.toJson()).toList();
    }
    data['obvious'] = this.obvious;
    return data;
  }
}

class Mentions {
  String id;
  String orth;
  String choiceId;
  String name;
  String commonName;
  String type;

  Mentions(
      {this.id,
      this.orth,
      this.choiceId,
      this.name,
      this.commonName,
      this.type});

  Mentions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orth = json['orth'];
    choiceId = json['choice_id'];
    name = json['name'];
    commonName = json['common_name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orth'] = this.orth;
    data['choice_id'] = this.choiceId;
    data['name'] = this.name;
    data['common_name'] = this.commonName;
    data['type'] = this.type;
    return data;
  }
}