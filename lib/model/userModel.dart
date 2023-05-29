import 'package:cloud_firestore/cloud_firestore.dart';

abstract class User {
  late final String email;
  late final String password;
}

class Member extends User {
  late final String memberID;
  late final String username;
  late final String name;
  late final String contacts;

  Member({
    required String email,
    required String password,
    required this.memberID,
    required this.username,
    required this.name,
    required this.contacts,
  }) : super() {
    this.email = email;
    this.password = password;
  }

  Member.fromMap(DocumentSnapshot<Object> data) {
    email = data['email'];
    password = data['password'];
    memberID = data['memberID'];
    username = data['username'];
    name = data['name'];
    contacts = data['contacts'];
  }

  Map<String, dynamic> toMap() {
    return {
      'email' : email,
      'password' : password,
      'username' : username,
    };
  }
}
