import 'package:skripsiii/model/userModel.dart';

class Member extends UserParent {
  late String _memberID;
  late String _username;
  late String _name;
  late String _contacts;
  late double _latitude;
  late double _longitude;

  Member.blank({
    String password = '',
    String email = '',
    String memberID = '',
    String username = '',
    String name = '',
    String contacts = '',
  }) : super(password: '', email: '');

  Member({
    required String email,
    required String password,
    required String memberID,
    required String username,
    required String name,
    required String contacts,
  }) : _memberID = memberID,
        _username = username,
        _name = name,
        _contacts = contacts,
        super(email: email, password: password);

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
      'username': _username,
      'memberID': _memberID,
      'name': _name,
      'contacts': _contacts,
    };
  }

  @override
  String toString() {
    return 'Member: { email: $email, password: $password, memberID: $_memberID, username: $_username, name: $_name, contacts: $_contacts }';
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  String get contacts => _contacts;

  set contacts(String value) {
    _contacts = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get memberID => _memberID;

  set memberID(String value) {
    _memberID = value;
  }
}
