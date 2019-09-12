class UserModel {
  String name;
  String email;
  String address;
  String gender;
  String userId;
  String imageUrl;
  String birthDay;

  UserModel(
      {this.name,
      this.email,
      this.address,
      this.gender,
      this.userId,
      this.imageUrl,
      this.birthDay});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    address = json['address'];
    gender = json['gender'];
    userId = json['userId'];
    imageUrl = json['imageUrl'];
    birthDay = json['birthDay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['userId'] = this.userId;
    data['imageUrl'] = this.imageUrl;
    data['birthDay'] = this.birthDay;
    return data;
  }
}