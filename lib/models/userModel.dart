import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String address;
  String gender;
  String userId;
  String imageUrl;
  String birthDay;
  int age;
  final DocumentReference reference;

  UserModel(this.name, this.address, this.gender, this.userId, this.imageUrl,
      this.reference, this.email, this.birthDay, this.age);

  UserModel.fromMap(Map<String, dynamic> map, {this.reference})
      : address = map['address'],
        name = map['name'],
        gender = map['gender'],
        email = map['email'],
        birthDay = map['birthDay'],
        age = map['age'],
        imageUrl = map['imageUrl'];

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
