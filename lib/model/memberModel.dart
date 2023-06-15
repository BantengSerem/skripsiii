import 'package:skripsiii/model/userModel.dart';

class Member extends UserParent {
  late String memberID;
  late String username;
  late String name;
  late String contacts;
  late double latitude;
  late double longitude;

  Member.blank({
    String password = '',
    String email = '',
    this.memberID = '',
    this.username = '',
    this.name = '',
    this.contacts = '',
  }) : super(password: '', email: '');

  Member({
    required String email,
    required String password,
    required this.memberID,
    required this.username,
    required this.name,
    required this.contacts,
  }) : super(email: email, password: password);

  // Member.fromMap(DocumentSnapshot<Object> data) {
  //   email = data['email'];
  //   password = data['password'];
  //   memberID = data['memberID'];
  //   username = data['username'];
  //   name = data['name'];
  //   contacts = data['contacts'];
  // }

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        email: json['email'],
        password: json['password'] ?? '',
        memberID: json['memberID'] ?? '',
        username: json['username'] ?? '',
        name: json['name'] ?? '',
        contacts: json['contacts'] ?? '',
      );

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'memberID': memberID,
      'name': name,
      'contacts': contacts,
    };
  }

  @override
  String toString() {
    return 'Member: { email: $email, password: $password, memberID: $memberID, username: $username, name: $name, contacts: $contacts }';
  }
}
