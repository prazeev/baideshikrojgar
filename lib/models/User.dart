class User {
  String email;
  String name;
  String token;
  String password;
  String id;
  int fbid = 0;
  String medium = 'normal';
  String picture = '';
  User({
    this.email,
    this.name,
    this.token,
    this.id,
    this.fbid,
    this.medium,
    this.password,
    this.picture,
  });
  setToken(String token) {
    this.token = token;
  }
}
