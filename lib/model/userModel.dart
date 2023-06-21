abstract class UserParent {
  late  String _email;
  late  String _password;

  UserParent({required String email, required String password})
      : _email = email,
        _password = password;

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }
}
