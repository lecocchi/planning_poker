class DataUser {
  String email = '';
  String name = '';
  bool isLogin = false;
  String avatar = '';

  static final DataUser _user = DataUser._internal();

  factory DataUser() {
    return _user;
  }

  DataUser._internal();
}
