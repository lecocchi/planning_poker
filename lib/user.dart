class User {

  String email = '';
  bool isLogin = false;


  static final User _user = User._internal();
  
  factory User() {
    return _user;
  }
  
  User._internal();
}